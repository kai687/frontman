# typed: false
# frozen_string_literal: true

require 'asciidoctor'
require 'frontman/renderers/renderer'

module Frontman
  class AsciidocRenderer < Frontman::Renderer
    def compile(layout)
      Asciidoctor.load(layout, safe: :safe)
    end

    def render_content(compiled, _content, _scope, _data)
      compiled.convert
    end
  end
end
