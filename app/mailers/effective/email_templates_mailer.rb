module Effective
  class EmailTemplatesMailer < ::ActionMailer::Base

    def mail(headers = {}, &block)
      email_template = Effective::EmailTemplate.where(template_name: action_name).first!
      assigns = (@assigns || {})

      # Parse assigns. Special keys for body and subject.
      body = assigns.delete(:body) || headers[:body] || headers['body']
      email_template.body = body if body.present?

      subject = assigns.delete(:subject) || headers[:subject] || headers['subject']
      email_template.subject = subject if subject.present?

      # Add any _url helpers
      assigns = route_url_assigns(email_template).merge(assigns)

      # Render from the template, possibly with updated body
      rendered = email_template.render(assigns)

      super(rendered.merge(headers.except(:body, :subject, 'body', 'subject')))
    end

    private

    def route_url_assigns(email_template)
      email_template.template_variables.select { |name| name.ends_with?('_url') }.inject({}) do |h, name|
        h[name] = public_send(name) if respond_to?(name); h
      end
    end

  end
end
