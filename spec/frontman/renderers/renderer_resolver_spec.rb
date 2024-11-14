# typed: false
# frozen_string_literal: true

require "./spec/spec_setup"
require "lib/frontman/renderers/markdown_renderer"
require "lib/frontman/renderers/renderer_resolver"

describe Frontman::RendererResolver do
  it "should list all builtin renderers" do
    expect(Frontman::RendererResolver.instance.all_renderers.keys).to eq %i[erb haml md slim]
  end

  it "should return true for a valid extension" do
    expect(Frontman::RendererResolver.instance.valid_extension?("md")).to eq true
  end

  it "should return false for an unsupported extension" do
    expect(Frontman::RendererResolver.instance.valid_extension?("foo")).to eq false
  end

  it "should register a custom renderer" do
    Frontman::RendererResolver.instance.add_renderer("foo", Frontman::MarkdownRenderer)
    expect(Frontman::RendererResolver.instance.valid_extension?("foo")).to eq true
  end
end
