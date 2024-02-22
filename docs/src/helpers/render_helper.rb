# frozen_string_literal: true

# Renders a partial with block
module RenderHelper
  def partial_block(template, data = {}, &block)
    partial_dir = Frontman::Config.get(:partial_dir)
    partial  = File.join(partial_dir, template)
    resource = Frontman::Resource.from_path(partial, nil, false)

    resource.render((block.call if block_given?), data)
  end
end
