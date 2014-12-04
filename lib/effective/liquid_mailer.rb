module Effective
  class LiquidMailer < ::ActionMailer::Base
    def mail(headers = {}, &block)
      # this be dangerous and requires ruby 2.0+
      mail_method = caller_locations(1,1)[0].label
      email_template = EffectiveEmailTemplates.get(mail_method)
      headers = headers.merge(email_template.mail_options)
      super(headers, &block)
    end
  end
end

