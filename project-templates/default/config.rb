# frozen_string_literal: true

register_data_dirs(['data'])
register_helper_dir('helpers')

register_layout 'sitemap.xml', nil
register_layout '*', 'main.erb'
# Or use 'main.haml' if you prefer using HAML:
# register_layout '*', 'main.haml'

Frontman::Config.set(:domain, 'https://example.com')
