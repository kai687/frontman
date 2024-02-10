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
    params(template: String, data: T.any(Hash, CustomStruct))
      .returns(String)
  end
  def partial(template, data = {})
    partial_dir = Frontman::Config.get(:partial_dir)
    r = Frontman::Resource.from_path(
      File.join(partial_dir, template), nil, false
    )

    # While rendering, if there's no current page we set it to to the resource
    # This allows using `content_for` directives in partials
    current_page = Frontman::App.instance.current_page
    Frontman::App.instance.current_page = r if current_page.nil?

    content = r.render(nil, data)

    Frontman::App.instance.current_page = current_page

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
