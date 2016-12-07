module EffectiveEmailTemplates
  class Engine < ::Rails::Engine
    engine_name 'effective_email_templates'

    # Include Helpers to base application
    initializer 'effective_email_templates.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper EffectiveEmailTemplatesHelper
      end
    end

    # Include acts_as_email_templatable concern and allow any ActiveRecord object to call it
    initializer 'effective_email_templates.active_record' do |app|
      ActiveSupport.on_load :active_record do
        # If you write a concern at all, it should be registered here
        #ActiveRecord::Base.extend(ActsAsAddressable::ActiveRecord)
      end
    end

    # Set up our default configuration options.
    initializer "effective_email_templates.defaults", :before => :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_email_templates.rb")
    end

  end
end

