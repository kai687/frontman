# frozen_string_literal: false

require "socket"
require "thor"
require "sinatra/base"
require "better_errors"
require "listen"
require "rack/livereload"
require "frontman/app"
require "frontman/bootstrapper"
require "frontman/builder/asset_pipeline"
require "frontman/config"
require "frontman/errors"
require "frontman/livereload"
require "frontman/resource"

module Frontman
  class CLI < Thor
    desc "serve", "Start a local preview server"
    def serve
      Frontman::Config.set(:mode, "serve")
      app = Frontman::App.instance
      Frontman::Bootstrapper.bootstrap_app(app)
      content_dir = Frontman::Config.get(:content_dir)
      if Frontman::Config.get(:auto_add_resources)
        Frontman::Bootstrapper.resources_from_dir(content_dir).each do |resource|
          app.sitemap_tree.add(resource)
        end
      end

      # Launch a websocket server for live reloading
      wss = Frontman::LiveReload::Server.new

      assets_pipeline = Frontman::Builder::AssetPipeline.new(
        app
          .asset_pipelines
          .filter { |p| %i[all serve].include?(p[:mode]) }
      )
      processes = assets_pipeline.run_in_background!(:before)

      helpers_dir = Frontman::Config.get(:helpers_dir)
      listen_to_dirs = Frontman::Config.get(:observe_dirs, fallback:
        [
          Frontman::Config.get(:layout_dir),
          Frontman::Config.get(:partial_dir),
          content_dir,
          helpers_dir
        ]).filter { |dir| Dir.exist?(dir) }
      app.refresh_data_files = true

      listener = Listen.to(*listen_to_dirs) do |modified, added|
        (added + modified).each do |m|
          resource_path = m.sub("#{Dir.pwd}/", "")
          begin
            if resource_path.start_with?(helpers_dir)
              helper_name = File.basename(resource_path).gsub(".rb", "")
              load("./#{resource_path}")
              app.register_helpers(
                [{
                  path: File.join(Dir.pwd, resource_path),
                  name: helper_name.split("_").collect(&:capitalize).join
                }]
              )
            elsif resource_path.start_with?(*listen_to_dirs)
              r = Frontman::Resource.from_path(resource_path)

              if resource_path.start_with?(content_dir)
                exists = app.sitemap_tree.from_resource(r)
                app.sitemap_tree.add(r) unless exists
              end

              r&.parse_resource(true)
            elsif resource_path.end_with?(".rb")
              load("./#{resource_path}")
            end
            wss.reload_client
          rescue Error
            # We ignore all errors to prevent the listener from crashing.
            # Errors will be surfaced by the server instead.
          end
        end
      end

      listener.start

      FrontmanServer.set :public_folder, Frontman::Config.get(:public_dir)

      port = Frontman::Config.get(:port)
      num_retries = Frontman::Config.get(:port_retries)

      port_retry_strategy = Frontman::Config.get(:port_retry_strategy, fallback: ->(p) {
        port_in_use = false

        (1 + num_retries).times do
          begin
            port_in_use = Socket.tcp("localhost", p, connect_timeout: 3) { true }
          rescue StandardError
            port_in_use = false
          end

          break unless port_in_use

          p += 1
        end

        raise Frontman::ServerPortError if port_in_use

        p
      })

      FrontmanServer.set(:port, port_retry_strategy.call(port))
      FrontmanServer.set(:bind, Frontman::Config.get(:host))

      FrontmanServer.run! do
        hostname = FrontmanServer.settings.bind
        host = "http://#{hostname}:#{FrontmanServer.settings.port}"
        print "== View your site at \"#{host}/\"\n"
        processes += assets_pipeline.run_in_background!(:after)
        at_exit { processes.each { |pid| Process.kill(0, pid) } }
      end
    end
  end
end

class FrontmanServer < Sinatra::Base
  set :server_settings,
      # Avoid having webrick displaying logs for every requests to the serve
      AccessLog: [],
      # Remove logger for WebRick, we have the one of sinatra already
      Logger: Rack::NullLogger.new(self)

  use Rack::LiveReload, host: Frontman::LiveReload.wss_host, port: Frontman::LiveReload.wss_port,
                        no_swf: true, source: :vendored
  use BetterErrors::Middleware
  BetterErrors.application_root = Dir.pwd

  get "*" do |path|
    app = Frontman::App.instance
    return redirect to app.get_redirect(path), 302 if app.get_redirect(path)

    tree = app.sitemap_tree.from_url(path)
    if tree&.resource
      extension = File.extname(tree.resource.destination_path)
      headers["Content-Type"] = Rack::Mime.mime_type(extension)
      tree.resource.render
    else
      halt 404
    end
  end
end
