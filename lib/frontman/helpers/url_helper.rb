# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

module UrlHelper
  extend T::Sig

  sig { params(url: String).returns(String) }
  def format_url(url)
    formatted = url.gsub('index.html', '')
                   .sub(%r{^/}, '')
                   .chomp('/')

    "/#{formatted}/".gsub('//', '/')
  end
end
