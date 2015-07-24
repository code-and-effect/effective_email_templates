$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "effective_email_templates/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "effective_email_templates"
  s.version     = EffectiveEmailTemplates::VERSION
  s.authors     = ["Code and Effect"]
  s.email       = ["info@codeandeffect.com"]
  s.homepage    = "https://github.com/code-and-effect/effective_email_templates"
  s.summary     = "Effective Email Templates provides an admin access to modify email templates"
  s.description = "Uses liquid templates"
  s.licenses    = ['MIT']

  s.files       = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "coffee-rails", ">= 3.2"
  s.add_dependency "haml", ">= 3.0"
  s.add_dependency "migrant", ">= 1.3"
  s.add_dependency "liquid", ">= 3.0.0"
  s.add_dependency "simple_form", ">= 1.0.0"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "effective_datatables", '>= 2.0.0'
  s.add_development_dependency "pry"
  s.add_development_dependency "devise"
end

