# frozen_string_literal: false

require 'thor'
require 'frontman/app'
require 'frontman/bootstrapper'
require 'frontman/builder/asset_pipeline'
require 'frontman/builder/builder'
require 'frontman/builder/mapping'
require 'frontman/builder/statistics_collector'
require 'frontman/config'
require 'frontman/toolbox/timer'
require 'frontman/sitemap_tree'

module Frontman
  class CLI < Thor
    option :parallel, type: :boolean
    option :verbose, type: :boolean
    desc 'build', 'Build the static website'
    def build
      Frontman::Config.set(:mode, 'build')
      app = Frontman::App.instance
      Frontman::Bootstrapper.bootstrap_app(app)
      content_dir = Frontman::Config.get(:content_dir)
      if Frontman::Config.get(:auto_add_resources)
        Frontman::Bootstrapper.resources_from_dir(content_dir).each do |resource|
          app.sitemap_tree.add(resource)
        end
      end

      assets_pipeline = Frontman::Builder::AssetPipeline.new(
        app.asset_pipelines.filter { |p| %i[all build].include?(p[:mode]) }
      )

      assets_pipeline.run!(:before)

      enable_parallel = options[:parallel]

      Frontman::Config.set(:parallel, enable_parallel)

      timer = Frontman::Toolbox::Timer.start

      build_dir = "#{Dir.pwd}/#{Frontman::Config.get(:build_dir)}"
      current_build_files = Dir.glob(File.join(build_dir, '/**/*')).reject do |f|
        File.directory? f
      end

      public_dir = Frontman::Config.get(:public_dir)
      assets_to_build = Dir.glob(File.join(public_dir, '**/*')).reject do |f|
        File.directory? f
      end

      mapping_path = "#{Dir.pwd}/_build.json"
      mapping = Frontman::Builder::Mapping.new(mapping_path)
      mapping.delete_file

      builder = Frontman::Builder::Builder.new
      builder.current_build_files = current_build_files

      builder.on('created, updated, deleted, unchanged', ->(build_file) {
        mapping.add_from_build_file(build_file)
      })

      assets = builder.build_assets(assets_to_build)
      redirects = builder.build_redirects

      resources_paths = builder.build_from_resources(
        Frontman::SitemapTree.resources
      )

      new_files = assets + redirects + resources_paths

      builder.delete_files(current_build_files - new_files)
      mapping.save_file

      assets_pipeline.run!(:after)

      Builder::StatisticsCollector.output(builder, mapping, timer, new_files)
    end
  end
end
