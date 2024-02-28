# frozen_string_literal: true

require 'frontman/context'

# Renders a partial with block
module RenderHelper
  def partial_block(template, data = {}, &block)
    partial_dir = Frontman::Config.get(:partial_dir)
    partial = File.join(partial_dir, template)
    resource = Frontman::Resource.from_path(partial, nil, false)
    context = Frontman::Context.new
    content = context.get_content_buffer(nil, &block)

    current_page = Frontman::App.instance.current_page
    Frontman::App.instance.current_page = resource if current_page.nil?

    content = resource.render(content, data)

    Frontman::App.instance.current_page = current_page

    content
  end
end
