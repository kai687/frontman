# frozen_string_literal: true

require 'frontman/context'

# Renders a partial with block
module RenderHelper
  def partial_block(template, data = {}, &block)
    partial_dir = Frontman::Config.get(:partial_dir)
    partial = File.join(partial_dir, template)
    context = Frontman::Context.new
    content = context.get_content_buffer(nil, &block)
    Frontman::Resource.from_path(partial, nil, false).render(content, data)
  end
end
