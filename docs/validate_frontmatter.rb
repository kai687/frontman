# frozen_string_literal: true

require 'frontman/app'
require 'frontman/bootstrapper'
require 'json-schema'
require 'yaml'

# JSON schema validation of frontmatter data
class Validator
  @unique = []

  def self.unique_titles(path, title)
    if @unique.include?(title)
      puts "Duplicate title detected in #{path}: #{title}"
      return false
    end
    @unique << title
    true
  end

  def unique_titles(path, title)
    self.class.unique_titles(path, title)
  end

  def initialize
    @schema = YAML.safe_load_file('schema.yml')
  end

  def validate(page)
    resource = page.resource
    data = resource.data.to_h || {}
    path = resource.file_path || ''

    begin
      JSON::Validator.validate!(@schema, data)
    rescue JSON::Schema::ValidationError => e
      puts "#{e.message} for #{path}"
      return false
    end

    unique_titles(path, data[:title]) ? true : false
  end
end

app = Frontman::App.instance
Frontman::Bootstrapper.bootstrap_app(app)

Frontman::Bootstrapper.resources_from_dir(Frontman::Config.get(:content_dir)).each do |resource|
  app.sitemap_tree.add(resource)
end

val = Validator.new

offense = false

app.sitemap_tree.get_all_pages.each do |page|
  next if page.url == 'sitemap.xml'
  # Index page doesn't use title and description frontmatter,
  # it uses site-wide data from `data/site.yml` instead.
  next if page == app.sitemap_tree

  offense = true unless val.validate(page)
end

puts 'No issues with your frontmatter!' unless offense
