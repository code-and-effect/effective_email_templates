EffectiveResources.setup do |config|
  # Authorization Method
  config.authorization_method = Proc.new { |controller, action, resource| true }

  # Default Submits
  config.default_submits = ['Save', 'Continue', 'Add New']

  # Email Settings
  #
  # Parent Mailer
  # config.parent_mailer = '::ApplicationMailer'

  # Mailer Layout
  # config.mailer_layout = 'effective_mailer_layout'

  # Deliver Method
  # config.deliver_method = :deliver_later

  # Default From
  config.mailer_sender = '"Sender" <sender@example.com>'

  # Send Admin correspondence To
  config.mailer_admin = '"Admin" <admin@example.com>'

  # Prefix all effective_* gem mailer subjects
  config.mailer_subject = Proc.new { |action, subject, resource, opts = {}| "[EXAMPLE] #{subject}" }
end
