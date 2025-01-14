# frozen_string_literal: false

require "fileutils"
require "thor"

module Frontman
  class CLI < Thor
    option :template
    option :force, type: :boolean
    desc "init", "Create a new Frontman project"

    def self.exit_on_failure?
      true
    end

    def init(path)
      template = options[:template] || "default"

      raise "Template #{template} does not exist!" unless template_exists?(template)

      target_dir = File.join(Dir.pwd, path == "." ? "" : path)

      unless allowed_to_modify_dir?(target_dir)
        say("Not creating a new Frontman project")
        return
      end

      copy_template(template, target_dir)

      command = path == "." ? "" : "cd #{path} && "
      command += "bundle install && "
      command += "bundle exec frontman serve"

      say("Your project is ready. Run `#{command}` and start developing!")
    end

    private

    def copy_template(template, dest)
      FileUtils.cp_r(
        "#{path_to_template(template)}/.",
        dest
      )
    end

    def allowed_to_modify_dir?(dir)
      return true if options[:force]
      return true if !Dir.exist?(dir) || Dir.empty?(dir)

      say("This folder already contains files. ")
      say("Initializing a new Frontman project here may override these files.")
      answer = ask("Are you sure you want to continue? [y/N]")

      answer.to_s.downcase == "y"
    end

    def template_exists?(template)
      Dir.exist?(path_to_template(template))
    end

    def path_to_template(template)
      File.join(__dir__, "../../../project-templates", template)
    end
  end
end
