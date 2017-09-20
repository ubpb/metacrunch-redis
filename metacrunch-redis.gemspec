# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "metacrunch/redis/version"

Gem::Specification.new do |spec|
  spec.name          = "metacrunch-redis"
  spec.version       = Metacrunch::Redis::VERSION
  spec.authors       = ["René Sprotte"]
  spec.summary       = %q{Redis package for the metacrunch ETL toolkit.}
  spec.homepage      = "http://github.com/ubpb/metacrunch-redis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.1.0"
  spec.add_dependency "redis",         ">= 4.0.0"
end
