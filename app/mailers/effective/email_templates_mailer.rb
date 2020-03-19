module Effective
  class EmailTemplatesMailer < ::ActionMailer::Base

    def mail(headers = {}, &block)
      email_template = Effective::EmailTemplate.where(template_name: action_name).first!

      # Parse Assigns. :body is a special key
      assigns = (@assigns || {})

      if (body = assigns.delete(:body))
        email_template.body = body
      end

      assigns = route_url_assigns(email_template).merge(assigns)

      # Render from the template, possibly with updated body
      rendered = email_template.render(assigns)

      super(rendered.merge(headers))
    end

    private

    def route_url_assigns(email_template)
      email_template.template_variables.select { |name| name.ends_with?('_url') }.inject({}) do |h, name|
        h[name] = public_send(name) if respond_to?(name); h
      end
    end

  end
end
