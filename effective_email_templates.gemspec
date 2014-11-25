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
  s.summary     = "Effective Email Templates"
  s.description = "Description for Effective Email Templates"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "coffee-rails"
  s.add_dependency "haml"
  s.add_dependency "migrant"
end

