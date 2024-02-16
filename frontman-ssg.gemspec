# frozen_string_literal: false

require './lib/frontman/version'

Gem::Specification.new do |s|
  s.name = 'frontman-ssg'
  s.version = Frontman::VERSION
  s.summary = 'A Middleman-inspired static site generator built for speed.'
  s.description = 'A Middleman-inspired static site generator built for speed.'
  s.authors = ['Devin Beeuwkes']
  s.email = 'devin@algolia.com'
  s.homepage = 'https://github.com/algolia/frontman/wiki'
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.executables = ['frontman']

  # Min Ruby version
  s.required_ruby_version = '>= 2.6.0', '<= 4'

  # Frontman dependencies
  s.add_runtime_dependency('base64')
  s.add_runtime_dependency('better_errors', '~> 2.6')
  s.add_runtime_dependency('bigdecimal')
  s.add_runtime_dependency('binding_of_caller', '~> 1.0')
  s.add_runtime_dependency('bundler')
  s.add_runtime_dependency('dotenv', '~> 2.7')
  s.add_runtime_dependency('em-websocket', '~> 0.5.3')
  s.add_runtime_dependency('erubis', '~> 2.7')
  s.add_runtime_dependency('haml', '~> 5.0')
  s.add_runtime_dependency('htmlentities', '~> 4.3')
  s.add_runtime_dependency('kramdown', '~> 2.1')
  s.add_runtime_dependency('kramdown-parser-gfm', '~> 1.1')
  s.add_runtime_dependency('listen', '~> 3.0')
  s.add_runtime_dependency('parallel', '~> 1.17')
  s.add_runtime_dependency('rack-livereload', '~> 0.5.1')
  s.add_runtime_dependency('rackup', '~> 2.1')
  s.add_runtime_dependency('rouge', '~> 4.2')
  s.add_runtime_dependency('sinatra', '~> 4.0')
  s.add_runtime_dependency('slim', '~> 5.2')
  s.add_runtime_dependency('sorbet-runtime', '~> 0.5')
  s.add_runtime_dependency('thor', '~> 1.2')
  s.add_runtime_dependency('yaml-front-matter', '0.0.1')
end
