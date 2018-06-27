# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gooddata_connectors_downloader_dummy/version'

Gem::Specification.new do |spec|
  spec.name          = 'gooddata_connectors_downloader_dummy'
  spec.version       = GoodData::Connectors::DummyDownloader::VERSION
  spec.authors       = ['Author']
  spec.email         = ['author@email.com']
  spec.description   = 'The gem wrapping the Dummy API connector implementation for Gooddata Connectors infrastructure'
  spec.summary       = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  spec.add_development_dependency 'rake-notes', '~> 0.2', '>= 0.2.0'
  spec.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  spec.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'aws-sdk-v1'
  spec.add_dependency 'gooddata', '~> 0.6', '= 0.6.54'
  spec.add_dependency 'require_all', '~> 1.4'
  spec.add_dependency 'peach', '~> 0.5'
end
