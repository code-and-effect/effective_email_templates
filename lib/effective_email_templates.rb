require "effective_email_templates/engine"
require "effective_email_templates/liquid_resolver"
require "effective_email_templates/email_view_template"
require "effective_email_templates/template_importer"
require "effective_email_templates/version"

require "effective/liquid_mailer"
Effective::LiquidMailer.send(:append_view_path, EffectiveEmailTemplates::LiquidResolver.new)

module EffectiveEmailTemplates

  mattr_accessor :email_templates_table_name
  mattr_accessor :authorization_method
  mattr_accessor :simple_form_options
  mattr_accessor :layout

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    if authorization_method.respond_to?(:call) || authorization_method.kind_of?(Symbol)
      raise Effective::AccessDenied.new() unless (controller || self).instance_exec(controller, action, resource, &authorization_method)
    end
    true
  end

  def self.get(slug)
    Effective::EmailTemplate.find_by_slug(slug) || Effective::EmailTemplate.new(slug: slug)
  end

end

