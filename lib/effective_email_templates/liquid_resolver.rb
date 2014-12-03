module EffectiveEmailTemplates
  class LiquidResolver < ::ActionView::Resolver

    attr_reader :name, :prefix
    alias_method :slug, :name

    def find_all(name, prefix=nil, partial=false, details={}, key=nil, locals=[])
      # key is used for caching which we won't do since
      # these templates can be updated at any time by
      # an admin. TODO: expire the resolver's cache when
      # a template is updated rather than skip caching
      @name = name
      @prefix = prefix

      return [] unless liquid_mailer?

      templates = collect_view_templates
      decorate(templates, [name, prefix, partial], details, locals)
      templates
    end

  private

    # Ensures all the resolver information is set in the template.
    def decorate(templates, path_info, details, locals)
      templates.each do |t|
        t.locals = locals
      end
    end

    def collect_view_templates
      effective_email_templates.map do |eet|
        EmailViewTemplate.new(eet)
      end
    end

    def effective_email_templates
      Array.wrap(Effective::EmailTemplate.find_by_slug(slug))
    end

    def liquid_mailer?
      prefix =~ /liquid/
    end
  end
end

