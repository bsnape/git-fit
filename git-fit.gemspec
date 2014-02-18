# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-fit/version'

Gem::Specification.new do |gem|
  gem.name        = 'git-fit'
  gem.version     = GitFit::VERSION
  gem.authors     = ['Ben Snape']
  gem.email       = ['bsnape@gmail.com']
  gem.description = %q{Git Fit}
  gem.summary     = %q{Git Fit}
  gem.homepage    = 'http://www.bensnape.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('ruport')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rugged')

end
