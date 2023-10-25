# Added to effective email templates mailers

module EffectiveEmailTemplatesMailer
  extend ActiveSupport::Concern

  def mail(headers = {}, &block)
    email_template = Effective::EmailTemplate.where(template_name: action_name).first
    return super if email_template.blank?

    assigns = (@assigns || {})

    # Parse body content if given
    body = assigns.delete(:body) || headers[:body] || headers['body']
    email_template.body = body if body.present?

    # Parse subject content if explicitly given
    # Otherwise the :subject key is a default and should be ignored in favor of the email template subject instead
    subject = assigns.delete(:subject)
    subject ||= (headers[:subject] || headers['subject']) if (headers[:custom_subject] || headers['custom_subject'])
    email_template.subject = subject if subject.present?

    # Add any _url helpers
    assigns = route_url_assigns(email_template, assigns).merge(assigns)

    # Render from the template, possibly with updated body and subject
    rendered = email_template.render(assigns)

    # Merge any other passed values
    merged = rendered.merge(headers.except(:body, :subject, :custom_subject, 'body', 'subject', 'custom_subject'))

    super(merged)
  end

  private

  def route_url_assigns(email_template, existing)
    route_variables = email_template.template_variables
      .select { |name| name.ends_with?('_url') }
      .reject { |name| existing.key?(name) || existing.key?(name.to_sym) }
    
    route_variables.inject({}) do |h, name|
      h[name] = public_send(name) if respond_to?(name); h
    end
  end

end
