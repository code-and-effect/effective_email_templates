EffectiveEmailTemplates.setup do |config|
  # Configure Database Tables
  config.email_templates_table_name = :email_templates

  # Authorization Method
  #
  # This method is called by all controller actions with the appropriate action and resource
  # If the method returns false, an Effective::AccessDenied Error will be raised (see README.md for complete info)
  #
  # Use via Proc (and with CanCan):
  # config.authorization_method = Proc.new { |controller, action, resource| can?(action, resource) }
  #
  # Use via custom method:
  # config.authorization_method = :my_authorization_method
  #
  # And then in your application_controller.rb:
  #
  # def my_authorization_method(action, resource)
  #   current_user.is?(:admin)
  # end
  #
  # Or disable the check completely:
  # config.authorization_method = false
  config.authorization_method = Proc.new { |controller, action, resource| authorize!(action, resource) } # CanCanCan

  # Layout Settings
  # Configure the Layout per controller, or all at once

  # config.layout = 'application'   # All EffectiveEmailTemplates controllers will use this layout
  config.layout = {
    email_templates: 'application',
    admin_email_templates: 'admin'
  }

  # Not allowed to select text/html by default
  config.select_content_type = false

end
