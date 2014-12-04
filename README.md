# Effective Email Templates

Description!!

Rails 3.2.x and Rails 4 Support

## Getting Started

Add to your Gemfile:

```ruby
gem 'effective_email_templates', :git => 'https://github.com/code-and-effect/effective_email_templates'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_email_templates:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table name (to use something other than the default 'email_templates'), manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```


## Usage

- Create some email templates at `/admin/email_templates`
- Create a mailer method for each email
  - Mailer objects need to inherit from `Effective::LiquidMailer`
  - Mailer methods and email template slugs need to match up
  - Email headers can be declared in the #mail method but can be overrided by the saved attributes on the Effective::EmailTemplate model.

```ruby
# app/mailers/user_liquid_mailer.rb
class UserLiquidMailer < Effective::LiquidMailer
  def after_create_user(user)
    mail(to: user.email)
  end
end
```

- Create mail objects and deliver them like normal

```ruby
mail = UserLiquidMailer.after_create_user(self)
mail.deliver
```

# Authorization

All authorization checks are handled via the config.authorization_method found in the config/initializers/ file.

It is intended for flow through to CanCan or Pundit, but that is not required.

This method is called by all controller actions with the appropriate action and resource

Action will be one of [:index, :show, :new, :create, :edit, :update, :destroy]

Resource will the appropriate Effective::Something ActiveRecord object or class

The authorization method is defined in the initializer file:

```ruby
# As a Proc (with CanCan)
config.authorization_method = Proc.new { |controller, action, resource| authorize!(action, resource) }
```

```ruby
# As a Custom Method
config.authorization_method = :my_authorization_method
```

and then in your application_controller.rb:

```ruby
def my_authorization_method(action, resource)
  current_user.is?(:admin) || EffectivePunditPolicy.new(current_user, resource).send('#{action}?')
end
```

or disabled entirely:

```ruby
config.authorization_method = false
```

If the method or proc returns false (user is not authorized) an Effective::AccessDenied exception will be raised

You can rescue from this exception by adding the following to your application_controller.rb:

```ruby
rescue_from Effective::AccessDenied do |exception|
  respond_to do |format|
    format.html { render 'static_pages/access_denied', :status => 403 }
    format.any { render :text => 'Access Denied', :status => 403 }
  end
end
```


## License

MIT License.  Copyright Code and Effect Inc. http://www.codeandeffect.com

You are not granted rights or licenses to the trademarks of Code and Effect

## TODO

- minimize gem dependencies
- remove unused non-admin routes and config option
- remove `caller` usage from Effective::LiquidMailer (or remove requirement for Ruby 2.0+)
- add `EffectiveEmailTemplates::present?` to check if a template model is present
- configurable default from address
- configurable prefix for subject line
- use autoload rather than require
- research panoramic gem's usage of the Resolver class and improve our Resolver usage
- enable multipart emails
- enable file attachments
- import factories/fixtures in install task

## Testing
















