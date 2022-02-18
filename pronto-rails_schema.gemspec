lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pronto/rails_schema/version'

Gem::Specification.new do |spec|
  spec.name          = 'pronto-rails_schema'
  spec.version       = Pronto::RailsSchemaVersion::VERSION
  spec.authors       = ['Raimondas Valickas']
  spec.email         = ['raimondas@vinted.com']

  spec.summary       = 'Pronto runner for detection of Rails schema changes.'
  spec.description   = 'Detects migration files and checks for changes in
    schema.rb or structure.sql files'
  spec.homepage      = 'https://github.com/raimondasv/pronto-schema_check'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'pronto', '~> 0.11.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
end
