# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-healthcheck/version'

Gem::Specification.new do |gem|
  gem.name = "git-healthcheck"
  gem.version = GitHealthCheck::VERSION
  gem.authors = ["Ben Snape"]
  gem.email = ["bsnape@gmail.com"]
  gem.description = %q{Git Health Check}
  gem.summary = %q{Git Health Check}
  gem.homepage = "http://wwww.bensnape.com"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("ruport")
  gem.add_development_dependency("rake")

end
