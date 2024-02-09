# typed: false
# frozen_string_literal: false

require 'liquid'
require 'frontman/renderers/renderer'

module Frontman
  class LiquidRenderer < Frontman::Renderer
    def compile(layout)
      Liquid::Template.error_mode = :strict
      Liquid::Template.parse(layout)
    end

    def render_content(compiled, _content, _scope, data)
      compiled.render!(data, { strict_variables: true, strict_filters: true })
    end
  end
end
