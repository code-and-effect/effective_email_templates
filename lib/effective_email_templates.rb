require 'liquid'
require 'effective_resources'
require 'effective_email_templates/engine'
require 'effective_email_templates/version'

module EffectiveEmailTemplates

  def self.config_keys
    [:email_templates_table_name, :select_content_type, :layout]
  end

  include EffectiveGem

  def self.permitted_params
    @permitted_params ||= [:from, :bcc, :cc, :subject, :body, :content_type]
  end

end
