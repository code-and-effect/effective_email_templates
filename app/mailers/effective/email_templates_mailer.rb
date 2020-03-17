module Effective
  class EmailTemplatesMailer < ::ActionMailer::Base

    def mail(headers = {}, &block)
      email_template = Effective::EmailTemplate.where(template_name: action_name).first!

      assigns = route_url_assigns(email_template).merge(@assigns || {})
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
