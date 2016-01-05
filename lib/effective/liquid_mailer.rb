module Effective
  class LiquidMailer < ::ActionMailer::Base
    def mail(headers = {}, &block)
      # this be dangerous and requires ruby 2.0+
      mail_method = caller_locations(1, 1)[0].label
      options = EffectiveEmailTemplates.get(mail_method).mail_options

      if options[:subject].present?
        options[:subject] = Liquid::Template.parse(options[:subject]).render(@to_liquid) rescue options[:subject]
      end

      super(headers.merge(options), &block)
    end
  end
end
