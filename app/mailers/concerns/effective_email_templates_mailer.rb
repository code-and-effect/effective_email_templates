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
    subject = assigns.delete(:subject) || headers[:subject] || headers['subject']
    email_template.subject = subject if subject.present?

    # If the body or subject are nil, they will be populated from the email_template

    # Add any _url helpers
    assigns = route_url_assigns(email_template, assigns).merge(assigns)

    # Render from the template, possibly with updated body and subject
    rendered = email_template.render(assigns)

    # Merge any other passed values
    merged = rendered.merge(headers.except(:body, :subject, 'body', 'subject'))

    # Finalize the subject_for Proc
    if respond_to?(:subject_for) # EffectiveResourcesMailer
      if (prefix = EffectiveResources.mailer_subject_prefix_hint).present?
        subject = subject_for(action_name, merged[:subject], email_template, merged)

        if subject.start_with?("#{prefix}#{prefix}") || subject.start_with?("#{prefix} #{prefix}")
          subject = subject.sub(prefix, '')
        end

        merged[:subject] = subject
      end
    end

    # Process body as plain text or html
    body = merged.fetch(:body) || ''

    # For text/plain emails
    if email_template.plain?
      stripped = body.strip

      if body.starts_with?('<p>') || body.strip.ends_with?('</p>')
        raise("unexpected html content found when when rendering text/plain email_template #{action_name}")
      end

      return super(merged) 
    end

    # For text/html emails
    layout = mailer_layout().presence || raise("expected a mailer layout when rendering text/html email_template #{action_name}")

    super(merged.except(:body, :content_type)) do |format|
      format.text { strip_tags(body) }
      format.html { render(layout: layout, inline: body) }
    end
  end

  def mailer_layout
    try(:mailer_settings).try(:mailer_layout) || EffectiveEmailTemplates.mailer_layout
  end

  private

  def strip_tags(html)
    return html if html.blank?
    view_context.strip_tags(html.gsub(/<\/(div|p|br|h[1-6])>/, "\n"))
  end

  def route_url_assigns(email_template, existing)
    route_variables = email_template.template_variables
      .select { |name| name.ends_with?('_url') }
      .reject { |name| existing.key?(name) || existing.key?(name.to_sym) }
    
    route_variables.inject({}) do |h, name|
      h[name] = public_send(name) if respond_to?(name); h
    end
  end

end
