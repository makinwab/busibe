# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "busibe/version"

Gem::Specification.new do |spec|
  spec.name          = "busibe"
  spec.version       = Busibe::VERSION
  spec.authors       = ["andela-bmakinwa"]
  spec.email         = ["makinwa37@gmail.com"]

  spec.summary       = "SMS service using Jusibe (jusibe.com)"
  spec.description   = "Busibe provides an easy interface to interact with the Jusibe API (jusibe.com)"
  spec.homepage      = "https://github.com/andela-bmakinwa/busibe"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "coveralls"
end
