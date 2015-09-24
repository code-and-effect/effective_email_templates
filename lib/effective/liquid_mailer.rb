module Effective
  class LiquidMailer < ::ActionMailer::Base
    append_view_path EffectiveEmailTemplates::LiquidResolver.new

    def mail(headers = {}, &block)
      # this be dangerous and requires ruby 2.0+
      mail_method = caller_locations(1,1)[0].label
      begin
        email_template = EffectiveEmailTemplates.get(mail_method)
        headers = headers.merge(email_template.mail_options)
        super(headers, &block)
      rescue Effective::MissingDbTemplate => e
        # WIP: write to log? send flash message to unknown page/user? write to effective_logger? configurable? configure to re-raise error?
      end
    end
  end
end

