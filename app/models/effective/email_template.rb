require 'liquid'
Liquid::Template.error_mode = :strict # Raises a SyntaxError when invalid syntax is used

module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    serialize :template, Liquid::Template

    validates :slug, uniqueness: true

    after_validation :precompile

    def precompile
      begin
        self.template = Liquid::Template.parse( body )
      rescue Liquid::SyntaxError => error
        errors.add :template, error.message
      end
    end

    def render( *args )
      template.render( *args )
    end

    def prepare(options = {})
      liquid_options = options.stringify_keys   # Liquid doesn't accept symbol keys
      email_body = render( liquid_options )

      options[:cc] = options.fetch(:cc, cc)
      options[:bcc] = options.fetch(:bcc, bcc)

      Effective::EmailTemplateMailer.templated_email(options[:to], email_body, self, options)
    end
  end
end

