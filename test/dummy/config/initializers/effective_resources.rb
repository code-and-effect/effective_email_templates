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

  # Default Froms radios collection
  # Used for effective gems email collection. Leave blank to fallback to just the mailer_sender
  config.mailer_froms = ['"Info" <info@example.com>', '"Admin" <admin@example.com>']

  # Prefix all effective_* gem mailer subjects
  # Do not add mailer_subject here because we test for it later
end
