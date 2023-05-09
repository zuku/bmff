# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bmff/version'

Gem::Specification.new do |spec|
  spec.name          = "bmff"
  spec.version       = BMFF::VERSION
  spec.authors       = ["Takayuki Ogiso"]
  spec.email         = ["gomatofu@gmail.com"]
  spec.summary       = %q{ISO BMFF Parser}
  spec.description   = %q{ISO Base Media File Format file parser.}
  spec.homepage      = "https://github.com/zuku/bmff"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").delete_if{|x| %r|/assets/| =~ x }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency "uuidtools"

  spec.add_development_dependency "bundler", ">= 2.2.33"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 5.0"
  spec.add_development_dependency "coveralls"
end
