require 'liquid'
Liquid::Template.error_mode = :strict # Raises a SyntaxError when invalid syntax is used

module Effective
  class EmailTemplate < ActiveRecord::Base
    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    serialize :template, Liquid::Template

    validates :slug, uniqueness: true, presence: true
    validates_format_of :slug, with: /\A([a-z]+_)*[a-z]+\z/, message: "must contain only lowercase letters and underscores (for example: an_example_slug)"
    validates :body, presence: true
    validates :from, presence: true
    validates :subject, presence: true

    after_validation :precompile

    def precompile
      begin
        self.template = Liquid::Template.parse( body )
      rescue Liquid::SyntaxError => error
        errors.add :template, error.message
      end
    end

    def mail_options
      {
        from: from,
        subject: subject,
        cc: cc,
        bcc: bcc
      }
    end

    def render( *args )
      template.render( *args )
    end
  end
end

