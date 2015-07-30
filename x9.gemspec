# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'version'

Gem::Specification.new do |gem|
  gem.authors       = ["Danilo Lima"]
  gem.email         = ["danilo.lima@wimdu.com"]
  gem.name          = "x9"
  gem.version       = X9::VERSION
  gem.summary       = "Gem to write logs"
  gem.description   = gem.summary
  gem.homepage      = "https://github.com/danilol/x9"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rake"

  gem.add_development_dependency "geminabox"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "delorean"
  gem.add_development_dependency "activesupport"
  gem.add_development_dependency "pry-byebug"
end
