require 'liquid'
Liquid::Template.error_mode = :strict # Raises a SyntaxError when invalid syntax is used

module Effective
  class EmailTemplate < ActiveRecord::Base

    self.table_name = EffectiveEmailTemplates.email_templates_table_name.to_s

    serialize :template, Liquid::Template

    validate :slug_needs_to_have_simple_format
    validates :slug,      presence: true, uniqueness: true
    validates :body,      presence: true
    validates :subject,   presence: true
    validates :from,      presence: true
    validates :template,  presence: true

    before_validation :try_precompile

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
      }.delete_if { |_, v| v.blank? }
    end

    def render( *args )
      template.render( *args )
    end

  private

    def try_precompile
      precompile if body_changed?
    end

    def slug_needs_to_have_simple_format
      # convert slug to symbol
      # add error if symbol has non-simple format (i.e. `:"symbol with spaces"` vs `:symbol_with_underscores`)
      if /[@$"]/ =~ slug.to_sym.inspect || slug.match(/[A-Z]/)
        errors.add(:slug, 'must have a simple format with no spaces, capital letters, and most punctuation (good: "hello_world", bad: "hello, world")')
      end
    end
  end
end
