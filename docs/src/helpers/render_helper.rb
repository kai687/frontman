# frozen_string_literal: true

require 'frontman/context'

# Renders a partial with block
module RenderHelper
  def partial_block(template, data = {}, &block)
    current_page = Frontman::App.instance.current_page
    current_page.context.send(:save_buffer)

    partial_dir = Frontman::Config.get(:partial_dir)
    partial = File.join(partial_dir, template)
    resource = Frontman::Resource.from_path(partial, nil, false)

    Frontman::App.instance.current_page = resource if current_page.nil?

    ctx = Frontman::Context.new
    content = resource.render(ctx.get_content_buffer(content, &(block if block_given?)))

    Frontman::App.instance.current_page = current_page
    current_page.context.send(:restore_buffer)
    content
  end
end
