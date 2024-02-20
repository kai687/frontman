# typed: true
# frozen_string_literal: true

require 'asciidoctor'
require 'frontman/renderers/renderer'

module Frontman
  # A custom renderer for the AciiDoc format
  class AsciidocRenderer < Frontman::Renderer
    def compile(layout)
      Asciidoctor.load(
        layout,
        # Support including content from other directories.
        safe: :unsafe,
        attributes: ['source-highlighter=rouge', 'sectlinks']
      )
    end

    def render_content(compiled, _content, _scope, _data)
      compiled.convert
    end
  end
end
