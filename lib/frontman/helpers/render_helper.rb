# typed: true
# frozen_string_literal: true

require 'frontman/config'
require 'frontman/context'
require 'frontman/renderers/markdown_renderer'
require 'frontman/renderers/erb_renderer'
require 'frontman/resource'
require 'sorbet-runtime'

module RenderHelper
  extend T::Sig

  sig do
    params(template: String, data: T.any(Hash, CustomStruct), block: T.nilable(T.proc.void))
      .returns(String)
  end
  def partial(template, data = {}, &block)
    current_page = Frontman::App.instance.current_page
    current_page.context.send(:save_buffer)

    partial = File.join(Frontman::Config.get(:partial_dir), template)
    resource = Frontman::Resource.from_path(partial, nil, false)

    Frontman::App.instance.current_page = resource if current_page.nil?

    ctx = Frontman::Context.new
    content = resource.render(ctx.get_content_buffer(content, &(block if Kernel.block_given?)),
                              data)

    Frontman::App.instance.current_page = current_page
    current_page.context.send(:restore_buffer)
    content
  end

  sig do
    params(
      page: Frontman::Resource, options: T.any(Hash, CustomStruct)
    ).returns(String)
  end
  def render_page(page, options = {})
    # We force not to render any layout
    options[:layout] = nil
    options[:ignore_page] = true

    # We don't need to cache here since it already done in the render function
    # of the resource
    page.render(nil, options)
  end

  sig do
    params(options: T.any(Hash, CustomStruct)).returns(String)
  end
  def render_current_page(options = {})
    render_page(Frontman::App.instance.current_page, options)
  end

  sig { params(content: String).returns(String) }
  def render_markdown(content)
    compiled = Frontman::MarkdownRenderer.instance.compile(content)
    Frontman::MarkdownRenderer.instance.render(
      compiled, nil, Frontman::Context.new, {}
    )
  end

  sig do
    params(
      content: String,
      template_data: T.nilable(Hash)
    ).returns(String)
  end
  def render_erb(content, template_data = nil)
    context = Frontman::Context.new

    if !template_data.nil? && template_data
      template_data.each do |key, value|
        context.singleton_class.send(:define_method, key) { value }
      end
    end

    compiled = Frontman::ErbRenderer.instance.compile(content)
    Frontman::ErbRenderer.instance.render(compiled, nil, context, {})
  end
end
