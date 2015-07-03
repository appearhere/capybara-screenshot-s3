# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara-screenshot-s3/version'

Gem::Specification.new do |spec|
  spec.name          = "capybara-screenshot-s3"
  spec.version       = Capybara::Screenshot::S3::VERSION
  spec.authors       = ["Michael Baird"]
  spec.email         = ["mbaird@users.noreply.github.com"]
  spec.summary       = %q{ Upload screenshots of test failures to S3. }
  spec.homepage      = "https://www.appearhere.co.uk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk', '~> 2.0'
  spec.add_dependency 'capybara-screenshot', '~> 1.0'
end
