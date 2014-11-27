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
    alias_method :template=, :precompile

  end
end
