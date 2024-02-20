# frozen_string_literal: true

require './src/renderers/asciidoc_renderer'
require './src/renderers/custom_markdown_renderer'

Frontman::Config.set :content_dir, 'content'
Frontman::Config.set :layout_dir, 'src/layouts'
Frontman::Config.set :partial_dir, 'src/partials'
Frontman::Config.set :port, 6969

register_data_dirs ['data']
register_helper_dir 'src/helpers'

# No layout for the sitemap. It gets rendered as is.
register_layout 'sitemap.xml', nil
register_layout '*', 'layout.slim'

register_custom_renderer 'adoc', Frontman::AsciidocRenderer
register_custom_renderer 'md', Frontman::ExtendedMarkdown

add_asset_pipeline(
  name: 'Run Tailwind and wait for changes',
  command: 'pnpm dev',
  timing: :before,
  mode: :serve
)

add_asset_pipeline(
  name: 'Build stylesheet with Tailwind',
  command: 'pnpm build',
  timing: :before,
  mode: :build
)
