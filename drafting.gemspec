# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drafting/version'

Gem::Specification.new do |spec|
  spec.name          = "drafting"
  spec.version       = Drafting::VERSION
  spec.authors       = ["Georg Ledermann"]
  spec.email         = ["mail@georg-ledermann.de"]

  spec.summary       = %q{Save draft version of any ActiveRecord object}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/ledermann/drafting"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 4.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "generator_spec"
end
