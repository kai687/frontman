# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/asciidoc_renderer'

describe Frontman::AsciidocRenderer do
  it 'should render Asciidoc correctly' do
    compiled = Frontman::AsciidocRenderer.instance.compile('== Hello!')
    expect(Frontman::AsciidocRenderer.instance.render_content(compiled, nil, nil, {})).to eq "<div class=\"sect1\">\n<h2 id=\"_hello\">Hello!</h2>\n<div class=\"sectionbody\">\n\n</div>\n</div>"
  end
end
