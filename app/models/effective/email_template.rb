require 'liquid'
Liquid::Template.error_mode = :strict # Raises a SyntaxError when invalid syntax is used

module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    validates :slug, uniqueness: true

    after_validation :precompile

    def precompile
      begin
        compiled_template = Liquid::Template.parse( body )
        marshalled_template = Marshal.dump( compiled_template )
        write_attribute( :template, marshalled_template )
      rescue Liquid::SyntaxError => error
        errors.add :template, error.message
      end
    end

    def template=( text = nil )
      raise Effective::RestrictedAttributeAccess, "Do not set the `template` attribute directly, set the `body` attribute and call `#precomple`."
    end

    def render( *args )
      Marshal.load(template).render( *args )
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

