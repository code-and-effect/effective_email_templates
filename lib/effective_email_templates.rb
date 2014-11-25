require "effective_email_templates/engine"
require "effective_email_templates/version"

module EffectiveEmailTemplates

  mattr_accessor :email_templates_table_name
  mattr_accessor :authorization_method
  mattr_accessor :simple_form_options
  mattr_accessor :layout

  def self.setup
    yield self
  end

end
