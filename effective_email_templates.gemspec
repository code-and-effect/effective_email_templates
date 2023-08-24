$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'effective_email_templates/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'effective_email_templates'
  s.version     = EffectiveEmailTemplates::VERSION
  s.authors     = ['Code and Effect']
  s.email       = ['info@codeandeffect.com']
  s.homepage    = 'https://github.com/code-and-effect/effective_email_templates'
  s.summary     = 'Effective Email Templates provides an admin access to modify email templates'
  s.description = 'Effective Email Templates provides an admin access to modify email templates'
  s.licenses    = ['MIT']

  s.files       = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'README.md']

  s.add_dependency 'rails'
  s.add_dependency 'liquid'
  s.add_dependency 'effective_bootstrap'
  s.add_dependency 'effective_datatables', '>= 4.0.0'
  s.add_dependency 'effective_resources'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'effective_test_bot'
  s.add_development_dependency 'effective_developer' # Optional but suggested
  s.add_development_dependency 'psych', '< 4'
end
