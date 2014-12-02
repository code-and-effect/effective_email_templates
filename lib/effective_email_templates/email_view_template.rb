module EffectiveEmailTemplates
  class EmailViewTemplate
    def initialize( effective_email_template )
      @effective_email_template = effective_email_template
    end

    attr_accessor :locals
    attr_reader :effective_email_template

    def render(view, locals, buffer=nil, &block)
      # The view object here is an anonymous view object (it has a class
      # of Class). It has all of the view helper methods inside of it.
      effective_email_template.render(locals)
    end

    def formats
      [:html]
    end

    def identifier
      effective_email_template.slug
    end

    def type
      formats.first
    end
  end
end

