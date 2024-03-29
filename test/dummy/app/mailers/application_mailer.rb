class ApplicationMailer < ActionMailer::Base
  include EffectiveMailer
  include EffectiveEmailTemplatesMailer

  def welcome(resource, opts = {})
    @assigns = assigns_for(resource)
    mail(to: resource.email, **headers_for(resource, opts))
  end

  def assigns_for(user)
    raise('expected a User') unless user.kind_of?(User)

    values = {
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    }

    { user: values }
  end

end
