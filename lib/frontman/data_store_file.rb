# typed: true
# frozen_string_literal: true

require 'date'
require 'pathname'
require 'sorbet-runtime'
require 'yaml'

module Frontman
  class DataStoreFile
    extend T::Sig
    attr_accessor :path, :file_name, :base_file_name, :parent,
                  :position, :data

    sig do
      params(
        path: String,
        file_name: String,
        base_file_name: String,
        parent: DataStore
      ).void
    end
    def initialize(path, file_name, base_file_name, parent)
      @path = path
      @file_name = file_name
      @base_file_name = base_file_name
      @parent = parent
      @data = load_data(@path)

      @@i ||= 0
      @position = @@i
      @@i += 1
    end

    sig { params(path: String).returns(T.untyped) }
    def load_data(path)
      (YAML.load_file(path, permitted_classes: [Date]) || {}).to_ostruct
    end

    def method_missing(method_id, *arguments, &block)
      @data.public_send(method_id, *arguments, &block)
    end

    def respond_to_missing?(method_id, _)
      @data.respond_to? method_id
    end

    sig { returns(String) }
    def current_path
      @path
    end

    sig { void }
    def refresh
      return unless Frontman::App.instance.refresh_data_files

      @data = load_data(@path)
    end

    sig { returns(String) }
    def to_s
      "<DataStoreFile #{@data.keys.join(', ')} >"
    end

    sig { returns(Frontman::DataStoreFile) }
    def to_ostruct
      self
    end
  end
end
