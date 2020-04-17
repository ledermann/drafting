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
  spec.required_ruby_version = '>= 2.5'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "railties"
end
