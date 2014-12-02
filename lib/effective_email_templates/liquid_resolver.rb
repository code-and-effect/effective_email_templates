module EffectiveEmailTemplates
  class LiquidResolver < ::ActionView::Resolver
    self.caching = false

    attr_reader :name, :prefix

    private

    # Ensures all the resolver information is set in the template.
    def decorate(templates, path_info, details, locals)
      templates.each do |t|
        t.locals = locals
      end
    end

    def find_templates(name, prefix, partial, details)
      @name = name
      @prefix = prefix

      return [] unless liquid_mailer?
      return view_templates
    end

    def view_templates
      effective_email_templates.map do |eet|
        EmailViewTemplate.new(eet)
      end
    end

    def effective_email_templates
      Array.wrap(EffectiveEmailTemplates.get(name))
    end

    def liquid_mailer?
      prefix =~ /liquid/
    end
  end
end

