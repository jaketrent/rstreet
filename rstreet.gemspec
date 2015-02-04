# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rstreet/version'

Gem::Specification.new do |spec|
  spec.name          = "rstreet"
  spec.version       = Rstreet::VERSION
  spec.authors       = ["jaketrent"]
  spec.email         = ["trent.jake@gmail.com"]
  spec.summary       = %q{Smart uploader for S3}
  spec.description   = %q{Generates a manifest file on first upload.  Minimizes future uploads by only sending changed files.}
  spec.homepage      = "https://github.com/jaketrent/rstreet"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "dot", "~> 1.0.2"
end
