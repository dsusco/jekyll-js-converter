require_relative 'lib/jekyll-js-converter/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-js-converter'
  spec.version       = JekyllJsConverter::VERSION
  spec.authors       = ['David Susco']
  spec.summary       = 'A JavaScript converter for Jekyll.'
  spec.homepage      = 'https://github.com/dsusco/jekyll-js-converter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR).grep(%r!^lib/!)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_runtime_dependency 'uglifier', '~> 4.2.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-jekyll', '~> 0.4'
end
