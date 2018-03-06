module EffectiveEmailTemplates
  class Engine < ::Rails::Engine
    engine_name 'effective_email_templates'

    # Set up our default configuration options.
    initializer "effective_email_templates.defaults", :before => :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_email_templates.rb")
    end

  end
end

