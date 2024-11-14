# typed: true
# frozen_string_literal: true

require "sorbet-runtime"

module Frontman
  class Config
    @defaults = {
      build_dir: "build",
      config_path: "./config.rb",
      content_dir: "source",
      auto_add_resources: true,
      fingerprint_assets: false,
      helpers_dir: "helpers",
      host: "localhost",
      layout_dir: "views/layouts",
      parallel: true,
      partial_dir: "views/partials",
      port: 4568,
      port_retries: 3,
      processor_count: 1,
      public_dir: "public"
    }
    class << self
      extend T::Sig
      attr_reader :defaults

      sig do
        params(
          key: T.any(String, Symbol),
          value: T.untyped
        ).returns(T.self_type)
      end
      def set(key, value)
        @@values ||= {}
        @@values[key.to_sym] = value
        self
      end

      sig do
        params(
          key: T.any(String, Symbol),
          fallback: T.untyped
        ).returns(T.untyped)
      end
      def get(key, fallback: nil)
        @@values ||= {}
        return @@values[key.to_sym] if @@values.key?(key.to_sym)
        if fallback.nil? && Frontman::Config.defaults.key?(key.to_sym)
          return Frontman::Config.defaults[key.to_sym]
        end

        fallback
      end

      sig { params(key: T.any(String, Symbol)).returns(T.self_type) }
      def delete(key)
        @@values ||= {}
        @@values.delete(key)
        self
      end

      sig { params(key: T.any(String, Symbol)).returns(T::Boolean) }
      def has?(key)
        @@values ||= {}
        @@values.key?(key.to_sym)
      end

      sig { returns(Hash) }
      def all
        @@values ||= {}
        @@values
      end
    end
  end
end
