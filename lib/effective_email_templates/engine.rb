module EffectiveEmailTemplates
  class Engine < ::Rails::Engine
    engine_name 'effective_email_templates'

    # Set up our default configuration options.
    initializer 'effective_email_templates.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_email_templates.rb")
    end

    # Include has_one_email_review concern and allow any ActiveRecord object to call it
    initializer 'effective_email_templates.active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend(HasOneEmailReview::ActiveRecord)
      end
    end

  end
end

