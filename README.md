
# Effective Email Templates

Create email templates that an admin can edit and then choose to send.

Rails 3.2.x and higher

## effective_email_templates 1.0

This is the 1.0 series of effective_email_templates.

This requires Twitter Bootstrap 4.

Please check out [Effective Email Templates 0.x](https://github.com/code-and-effect/effective_email_templates/tree/bootstrap3) for more information using this gem with Bootstrap 3.


## Getting Started

Add to your Gemfile:

```ruby
gem 'effective_email_templates'
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

## Creating Email Templates

This is very similar to creating other emails in Rails.

1. Create a new mailer object (i.e. `/app/mailers/template_mailer.rb`)
    - Mailer objects need to inherit from `Effective::LiquidMailer`

2. Create a method inside the mailer object based on the name of your email (i.e. `def welcome_email`)

3. Create a default email template file (i.e. `/app/views/template_mailer/welcome_email.liquid`)
    - Start out with a plain text email (without any variables and we'll show you how to add dynamic content below)
    - Add the email subject and from address at the top of the email. For example:

    ```yaml
    ---
    subject: 'Hello User'                   # REQUIRED
    from: 'effective@email_templates.com'   # REQUIRED
    cc: 'my_friend@email_templates.com'     # optional
    bcc: 'my_secret_friend@example.com'     # optional
    ---
    Hello new user! I'm a liquid template that will be editable to site admins and/or users.
    ```

4. Run this rake task to import this email template from the filesystem to the database (where it will be editable)
    - Remember to do this in your staging and production environments as well!
    - This task can be run even when no new templates have been added and will not overwrite existing
      database templates.  This allows you to run the rake task in a deploy script if you are adding new
      templates frequently.

    ```console
    rake effective_email_templates:import_templates
    ```

5. Visit `localhost:3000/admin/email_templates` in your browser to edit templates.

6. Run this rake task to overwrite to initial state default database email templates that have already been changed. This will touch email templates created only from filesystem.
    ```console
    rake effective_email_templates:overwrite_templates
    ```


## Making Content Dynamic

```liquid
Welcome to our site.  We think you're {{ adjective }}!
```

The corresponding Mailer:

```ruby
# app/mailers/template_mailer.rb
class TemplateMailer < Effective::LiquidMailer
  def welcome_email(user)
    @to_liquid = {
      'adjective' => 'awesome'
    }
    mail(to: user.email)
  end
end
```

Send the emails like normal:

```ruby
mail = TemplateMailer.welcome_email(user)
mail.deliver
```


## Authorization

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

### Permissions

To allow a user to see the admin area, using CanCan:

```ruby
can :admin, :effective_email_templates
```


## License

MIT License.  Copyright Code and Effect Inc. http://www.codeandeffect.com

You are not granted rights or licenses to the trademarks of Code and Effect

## TODO

- minimize gem dependencies
- remove unused non-admin routes and config option
- Add an admin alert if there are mailer methods that do not have associated email templates
- Show admin what the available arguments are for each template
- remove `caller` usage from Effective::LiquidMailer (or remove requirement for Ruby 2.0+)
- add `EffectiveEmailTemplates::present?` to check if a template model is present
  - notify the app but don't raise an error if template is not present when an email is sent
- configurable default from address
- configurable prefix for subject line
- use autoload rather than require
- research panoramic gem's usage of the Resolver class and improve our Resolver usage
- enable multipart emails
- enable file attachments
- import factories/fixtures in install task

## Testing

