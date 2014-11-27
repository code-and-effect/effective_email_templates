module Effective
  class EmailTemplateMailer < ActionMailer::Base
    def templated_email(address, body, email_template, options)
      @body = body
      mail(
        to: address,
        from: email_template.from,
        subject: email_template.subject,
        cc: options.fetch(:cc, false),
        bcc: options.fetch(:bcc, false),
      )
    end
  end
end
