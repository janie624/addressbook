$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "addressbook/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "addressbook"
  s.version     = Addressbook::VERSION
  s.authors     = ["Gommy Lee"]
  s.email       = ["sieraruo@gmail.com"]
  s.homepage    = ""
  s.summary     = "Addressbook"
  s.description = "Addressbook cloud interface."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_runtime_dependency 'rails', '~> 4.1', '>= 4.1.5'
  s.add_dependency 'jquery-rails', '~> 3.1', '>= 3.1.1'
  s.add_dependency 'activeresource', '~> 4.0', '>= 4.0.0'
  s.add_dependency 'activeresource-response', '~> 1.1', '>= 1.1.1'
  s.add_dependency 'carrierwave', '~> 0.10', '>= 0.10.0'
  s.add_dependency 'fog', '~> 1.23', '>= 1.23.0'
  s.add_dependency 'mini_magick', '~> 3.7', '>= 3.7.0'
  s.add_dependency 'kaminari', '~> 0.15', '>= 0.15.1'
  s.add_development_dependency "sqlite3", '~> 1.3', '>= 1.3.9'
  s.add_development_dependency "factory_girl_rails", '~> 4.4', '>= 4.4.1'
  s.add_development_dependency 'ffaker', '~> 1.24.0', '>= 1.24.0'
  s.add_development_dependency 'rspec-rails', '~> 2.99', '>= 2.99.0'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0', '>= 1.0.1'
end
