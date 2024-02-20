# frozen_string_literal: true

# Renders a partial with block
module RenderHelper
  def partial_block(template, data = {}, &block)
    partial_dir = Frontman::Config.get(:partial_dir)
    partial  = File.join(partial_dir, template)
    resource = Frontman::Resource.from_path(partial, nil, false)
    app = Frontman::App.instance

    current_page = app.current_page
    app.current_page = resource if current_page.nil?

    content = resource.render(block.call, data)

    app.current_page = current_page

    content
  end
end
