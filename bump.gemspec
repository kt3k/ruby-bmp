# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bump/version'

Gem::Specification.new do |spec|
  spec.name          = "bmp"
  spec.version       = Bump::VERSION
  spec.authors       = ["Yoshiya Hinosawa"]
  spec.email         = ["stibium121@gmail.com"]
  spec.description   = "Bump version numbers in a repository"
  spec.summary       = "Bump version numbers in a repository"
  spec.homepage      = "https://github.com/kt3k/bump"
  spec.license       = "MIT License"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "slop", "~> 3.4.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
