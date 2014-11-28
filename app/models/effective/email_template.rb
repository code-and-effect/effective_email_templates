require 'liquid'

module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

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

    def prepare(address, render_options, options = {})
      email_body = render( render_options )

      options[:cc] = options.fetch(:cc, cc)
      options[:bcc] = options.fetch(:bcc, bcc)

      Effective::EmailTemplateMailer.templated_email(address, email_body, self, options)
    end
  end
end

