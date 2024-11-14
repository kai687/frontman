# frozen_string_literal: true

require "kramdown/parser"
require "kramdown/converter"
require "kramdown/element"

module Kramdown
  module Converter
    # Add header links to h2 and beyond
    class WithHeaderlink < Html
      CALLOUT_PATTERN = /\[!(NOTE|TIP|WARNING|IMPORTANT|CAUTION)\]/.freeze

      def convert_header(element, indent)
        attr = element.attr.dup
        attr["id"] = generate_id(element.options[:raw_text]) if @options[:auto_ids] && !attr["id"]
        if attr["id"] && in_toc?(element)
          @toc << [
            element.options[:level],
            attr["id"],
            element.children
          ]
        end

        level = output_header_level(element.options[:level])
        if level > 1
          link = Element.new(:a)
          link.attr["href"] = "##{attr["id"]}"
          link.children += element.children
          element.children.clear
          element.children << link
        end

        format_as_block_html("h#{level}", attr, inner(element, indent), indent)
      end

      def convert_blockquote(element, indent)
        content = element.children.map { |child| convert(child, indent) }.join
        if content =~ CALLOUT_PATTERN
          callout_type = Regexp.last_match(1).downcase
          content.gsub!(CALLOUT_PATTERN, "")
          format_as_block_html("aside", {class: callout_type}, content, indent)
        else
          super
        end
      end
    end
  end
end
