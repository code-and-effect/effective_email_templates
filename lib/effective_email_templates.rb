require "effective_email_templates/engine"
require "effective_email_templates/version"

module EffectiveEmailTemplates

  mattr_accessor :email_templates_table_name
  mattr_accessor :authorization_method
  mattr_accessor :layout

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    @_exceptions ||= [Effective::AccessDenied, (CanCan::AccessDenied if defined?(CanCan)), (Pundit::NotAuthorizedError if defined?(Pundit))].compact

    return !!authorization_method unless authorization_method.respond_to?(:call)
    controller = controller.controller if controller.respond_to?(:controller)

    begin
      !!(controller || self).instance_exec((controller || self), action, resource, &authorization_method)
    rescue *@_exceptions
      false
    end
  end

  def self.authorize!(controller, action, resource)
    raise Effective::AccessDenied.new('Access Denied', action, resource) unless authorized?(controller, action, resource)
  end

  def self.get(slug)
    Effective::EmailTemplate.find_by_slug(slug) || Effective::EmailTemplate.new(slug: slug)
  end

end

