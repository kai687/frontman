# typed: true
# frozen_string_literal: true

require "frontman/renderers/markdown_renderer"

require_relative "headerlinks"
require_relative "wikilinks"

module Frontman
  # An extended markdown renderer to handle wikilinks and add headerlinks
  class ExtendedMarkdown < MarkdownRenderer
    def compile(layout)
      Kramdown::Document.new(
        layout,
        syntax_highlighter: "rouge",
        parse_block_html: true,
        fenced_code_blocks: true,
        input: "Wikilinks",
        with_toc_data: true,
        smartypants: true,
        hard_wrap: false
      )
    end

    def render_content(compiled, _content, _scope, _data)
      compiled.to_WithHeaderlink
    end
  end
end
