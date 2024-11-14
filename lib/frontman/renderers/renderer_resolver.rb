# typed: true
# frozen_string_literal: true

require "frontman/renderers/renderer"
require "frontman/renderers/erb_renderer"
require "frontman/renderers/haml_renderer"
require "frontman/renderers/markdown_renderer"
require "frontman/renderers/slim_renderer"
require "singleton"
require "sorbet-runtime"

module Frontman
  class RendererResolver
    extend T::Sig
    include Singleton

    sig { params(extension: String).returns(T.nilable(Frontman::Renderer)) }
    def get_renderer(extension)
      all_renderers[extension.to_sym]
    end

    sig { returns(T::Hash[Symbol, Frontman::Renderer]) }
    def all_renderers
      @all_renderers ||= {
        erb: Frontman::ErbRenderer.instance,
        haml: Frontman::HamlRenderer.instance,
        md: Frontman::MarkdownRenderer.instance,
        slim: Frontman::SlimRenderer.instance
      }
    end

    sig { params(extension: String, renderer: T.untyped).void }
    def add_renderer(extension, renderer)
      all_renderers[extension.to_sym] = renderer.instance
    end

    sig { params(extension: String).returns(T::Boolean) }
    def valid_extension?(extension)
      # We have to append html and txt manually here
      # so we can extract front matter data from them
      all_renderers.keys.push(:html, :txt).include?(extension.to_sym)
    end
  end
end
