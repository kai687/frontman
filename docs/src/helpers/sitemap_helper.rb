# frozen_string_literal: true

# helper functions for working with the sitemap
module SitemapHelper
  # sorts pages based on position frontmatter key
  def sorted_sitemap
    sorted = app.sitemap_tree.get_all_pages.reject { |p| p.url == 'sitemap.xml' }
    sorted = sorted.each do |p|
      p.position = root?(p) ? -1 : p.resource.data&.position || 1000
    end
    sorted.sort_by(&:position)
  end

  # returns true if the page is the root of the sitemap tree
  def root?(page = current_tree)
    page == app.sitemap_tree
  end

  # gets the sidebar label
  def sidebar_label(page)
    page&.resource&.data&.sidebar_label || page&.resource&.data&.title
  end

  # gets the link
  def link_to(page)
    base_url = Frontman::Config.get :base_url
    root?(page) ? "#{base_url}/" : "#{base_url}/#{page&.final_url}"
  end

  # gets neighbors of a page in the sitemap tree
  def neighbors(sitemap, index)
    previous_page = index.zero? ? nil : sitemap[index - 1]
    next_page = index == sitemap.last ? nil : sitemap[index + 1]
    [previous_page, next_page]
  end
end
