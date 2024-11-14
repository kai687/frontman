# typed: strict
# frozen_string_literal: false

require "htmlentities"
require "singleton"
require "sorbet-runtime"

module LinkHelper
  extend T::Sig

  sig { void }
  def initialize
    @ids = T.let({}, T::Hash[String, Integer])
  end

  sig { params(str: String, salt: String).returns(String) }
  def generate_id(str, salt = "")
    id = slugify(str)
    salted_id = salt.to_s + id

    @ids[salted_id] ||= 0
    @ids[salted_id] = T.must(@ids[salted_id]) + 1
    @ids[salted_id] == 1 ? id : "#{id}-#{@ids[salted_id]}"
  end

  sig { void }
  def reset_ids_generation
    @ids = {}
  end

  sig { params(string: String).returns(String) }
  def slugify(string)
    HTMLEntities.new
                .decode(string)
                .gsub(%r{</?[^>]*>}, "")
                .gsub(/\s/, "-")
                .gsub(%r{[\[\]()/",`'&<>.*]}, "")
                .downcase
  end
end
