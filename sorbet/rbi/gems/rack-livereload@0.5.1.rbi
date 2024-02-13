# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rack-livereload` gem.
# Please instead update this file by running `bin/tapioca gem rack-livereload`.

# source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#3
module Rack
  class << self
    # source://rack/3.0.9/lib/rack/version.rb#31
    def release; end

    # source://rack/3.0.9/lib/rack/version.rb#23
    def version; end
  end
end

# source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#4
class Rack::LiveReload
  # @return [LiveReload] a new instance of LiveReload
  #
  # source://rack-livereload//lib/rack/livereload.rb#9
  def initialize(app, options = T.unsafe(nil)); end

  # source://rack-livereload//lib/rack/livereload.rb#17
  def _call(env); end

  # Returns the value of attribute app.
  #
  # source://rack-livereload//lib/rack/livereload.rb#7
  def app; end

  # source://rack-livereload//lib/rack/livereload.rb#13
  def call(env); end

  private

  # source://rack-livereload//lib/rack/livereload.rb#41
  def deliver_file(file); end
end

# source://rack-livereload//lib/rack/livereload/body_processor.rb#5
class Rack::LiveReload::BodyProcessor
  # @return [BodyProcessor] a new instance of BodyProcessor
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#22
  def initialize(body, options); end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#91
  def app_root; end

  # Returns the value of attribute content_length.
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#11
  def content_length; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#30
  def force_swf?; end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#95
  def host_to_use; end

  # Returns the value of attribute livereload_added.
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#11
  def livereload_added; end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#17
  def livereload_local_uri; end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#103
  def livereload_source; end

  # Returns the value of attribute new_body.
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#11
  def new_body; end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#70
  def process!(env); end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#66
  def processed?; end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#13
  def protocol; end

  # source://rack-livereload//lib/rack/livereload/body_processor.rb#99
  def template; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#38
  def use_vendored?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/body_processor.rb#34
  def with_swf?; end
end

# source://rack-livereload//lib/rack/livereload/body_processor.rb#7
Rack::LiveReload::BodyProcessor::HEAD_TAG_REGEX = T.let(T.unsafe(nil), Regexp)

# source://rack-livereload//lib/rack/livereload/body_processor.rb#6
Rack::LiveReload::BodyProcessor::LIVERELOAD_JS_PATH = T.let(T.unsafe(nil), String)

# source://rack-livereload//lib/rack/livereload/body_processor.rb#8
Rack::LiveReload::BodyProcessor::LIVERELOAD_PORT = T.let(T.unsafe(nil), Integer)

# source://rack-livereload//lib/rack/livereload/body_processor.rb#9
Rack::LiveReload::BodyProcessor::LIVERELOAD_SCHEME = T.let(T.unsafe(nil), String)

# source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#5
class Rack::LiveReload::ProcessingSkipAnalyzer
  # @return [ProcessingSkipAnalyzer] a new instance of ProcessingSkipAnalyzer
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#12
  def initialize(result, env, options); end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#35
  def bad_browser?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#22
  def chunked?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#43
  def get?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#39
  def html?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#30
  def ignored?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#26
  def inline?; end

  # @return [Boolean]
  #
  # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#18
  def skip_processing?; end

  class << self
    # @return [Boolean]
    #
    # source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#8
    def skip_processing?(result, env, options); end
  end
end

# source://rack-livereload//lib/rack/livereload/processing_skip_analyzer.rb#6
Rack::LiveReload::ProcessingSkipAnalyzer::BAD_USER_AGENTS = T.let(T.unsafe(nil), Array)
