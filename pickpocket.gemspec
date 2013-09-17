# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pickpocket/version'

Gem::Specification.new do |spec|
  spec.name          = "pickpocket"
  spec.version       = Pickpocket::VERSION
  spec.authors       = ["Kim Daekwon"]
  spec.email         = ["propellerheaven@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = "pickpocket.lapisan.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  spec.add_runtime_dependency "pocket-ruby"
  spec.add_runtime_dependency "twitter"
  spec.add_runtime_dependency "dotenv"
  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "nokogiri"
end
