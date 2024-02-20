# frozen_string_literal: true

require 'kramdown/parser/kramdown'
require 'kramdown-parser-gfm'

module Kramdown
  module Parser
    # Based on the API doc comment: https://github.com/gettalong/kramdown/blob/master/lib/kramdown/parser/kramdown.rb
    class Wikilinks < GFM
      def initialize(source, options)
        super

        # Override existing Table parser to use our own start Regex which adds a check for wikilinks
        @@parsers.delete(:table) # Data(:table, TABLE_START, nil, "parse_table")
        self.class.define_parser(:table, TABLE_START)

        @span_parsers.unshift(:wikilinks)
      end

      # Override Kramdown table pipe check so we can write `[[pagename|Anchor Text]]`.
      # https://github.com/gettalong/kramdown/blob/master/lib/kramdown/parser/kramdown/table.rb
      # Regex test suite: https://regexr.com/5rb9q
      # Fail for wikilinks in the same line
      TABLE_PIPE_CHECK = /^(?:\|(?!\[\[)|[^\[]*?(?!\[\[)[^\[]*?\||.*?(?:\[\[[^\]]+\]\]).*?\|)/
      TABLE_LINE = /#{TABLE_PIPE_CHECK}.*?\n/ # Unchanged
      TABLE_START = /^#{Kramdown::OPT_SPACE}(?=\S)#{TABLE_LINE}/ # Unchanged

      WIKILINKS_MATCH = /\[\[(.*?)\]\]/
      define_parser(:wikilinks, WIKILINKS_MATCH, '\[\[')

      def parse_wikilinks
        line_number = @src.current_line_number

        # Advance parser position
        @src.pos += @src.matched_size

        wikilink = Wikilink.parse(@src[1])
        el = Element.new(
          :a,
          nil,
          {
            href: wikilink.url,
            title: wikilink.title
          },
          location: line_number
        )
        add_text(wikilink.title, el)
        @tree.children << el

        el
      end

      # [[page_name|Optional title]]
      class Wikilink
        def self.parse(text)
          url, label = text.split('|', 2)
          new(url.downcase, label)
        end

        attr_accessor :url, :title

        def initialize(url, label)
          page = Frontman::App.instance.sitemap_tree.from_url(url)
          resource = page&.resource
          raise "No page exists at `#{url}`. Try a different path." unless resource

          if label.nil? && resource.data.title.empty?
            raise <<-END_OF_ERROR
              Page #{resource.file_path} doesn't have a `title:` frontmatter.
              Add an explicit link label `[[url|text]]`"
            END_OF_ERROR
          end

          @title = label.nil? ? resource.data.title : label
          @url = page.final_url
        end
      end
    end
  end
end
