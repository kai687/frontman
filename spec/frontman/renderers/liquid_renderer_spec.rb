# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'lib/frontman/renderers/liquid_renderer'

describe Frontman::LiquidRenderer do
  it 'should render Liquid correctly' do
    compiled = Frontman::LiquidRenderer.instance.compile("t{{ 'es' }}t")
    expect(Frontman::LiquidRenderer.instance.render_content(compiled, nil, Frontman::Context.new, {})).to eq 'test'
  end

  it 'should throw an error with incorrect Liquid syntax' do
    expect { Frontman::LiquidRenderer.instance.compile('t{{ |! }}t') }.to raise_error Liquid::SyntaxError
  end

  it 'should send the data to the view' do
    compiled = Frontman::LiquidRenderer.instance.compile('t{{ string }}t')
    expect(Frontman::LiquidRenderer.instance.render_content(compiled, nil, Frontman::Context.new, 'string' => 'es')).to eq 'test'
  end
end
