# -*- encoding: utf-8 -*-

require File.expand_path('../lib/knife-role-spaghetti', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'knife-role-spaghetti'
  gem.summary       = 'Cut through the Role spaghetti with a Knife, Chef.'
  gem.description   = 'This knife plugin extends the `knife role` command.'
  gem.version       = KnifeRoleSpaghetti::VERSION
  gem.license       = 'Apache License 2.0'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'chef', '>= 10.12'
  gem.add_dependency 'ruby-graphviz', '~> 1.2.1'
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'aruba', '~> 0.5'
  gem.add_development_dependency 'aruba-doubles', '~> 1.2'
  gem.add_development_dependency 'cane', '~> 2.5'
  gem.add_development_dependency 'rubocop', '~> 0.49.0'

  gem.authors       = ['Mike Fiedler']
  gem.email         = ['miketheman@gmail.com']
  gem.homepage      = 'http://www.miketheman.net'
end
