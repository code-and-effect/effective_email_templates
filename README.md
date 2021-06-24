
# Effective Email Templates

Create email templates that an admin can edit and then send.

Rails 3.2.x through Rails 6

## effective_email_templates 1.0

This is the 1.0 series of effective_email_templates.

This requires Twitter Bootstrap 4.

Please check out [Effective Email Templates 0.x](https://github.com/code-and-effect/effective_email_templates/tree/bootstrap3) for more information using this gem with Bootstrap 3.


## Getting Started

Add to your Gemfile:

```ruby
gem 'haml-rails' # or try using gem 'hamlit-rails'
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

And import the provided welcome email template:

```ruby
rake effective_email_templates:import
```

## Admin View

To manage the content of the email templates, navigate to `/admin/email_templates` or add,

`link_to 'Email Templates', effective_email_templates.admin_email_templates_path` to your menu.

## Create Email Templates

The installer already created an `app/mailers/email_templates_mailer.rb`. You can change this name. And additional mailers can be created, just make sure they extend from `Effective::EmailTemplatesMailer`.

To create an email template:

1. Create a method inside the mailer, like `def welcome`. The `@assigns` instance variable should contain all the variables that are passed to the liquid view. Any variables that end in `_url` like `root_url` will be automatically expanded.

```ruby
# app/mailers/email_templates_mailer.rb
class EmailTemplatesMailer < Effective::EmailTemplatesMailer
  def welcome(user)
    @assigns = {
      user: {
        first_name: user.first_name,
        last_name: user.last_name
      }
      adjective: 'awesome'
    }

    mail(to: user.email)
  end
end
```

2. Create a .liquid file in `app/views/email_templates_mailer/welcome.liquid`.

```yaml
---
subject: 'Welcome {{ user.first_name }}'  # REQUIRED
from: 'admin@example.com'               # REQUIRED
cc: 'info@example.com'                  # optional
bcc: 'info@example.com'                 # optional
---
Welcome {{ user.first_name }} {{ user.last_name }}!

I am a liquid template that is imported to the database, and is then editable.

Thanks for using our site at {{ root_url }}.
```

3. Run `rake effective_email_templates:import` or `rake effective_email_templates:overwrite`

- Remember to do this in your staging and production environments as well!

- The import task can be run even when no new templates have been added and will not overwrite existing
  database templates.  This allows you to run the rake task in a deploy script if you are adding new
  templates frequently.

4. Send the emails like normal:

```ruby
EmailTemplatesMailer.welcome(user).deliver
```

## Authorization

All authorization checks are handled via the effective_resources gem found in the `config/initializers/effective_resources.rb` file.


### Permissions

To allow a user to see the admin area, using CanCan:

```ruby
can [:index, :edit, :update, :destroy], Effective::EmailTemplate
can :admin, :effective_email_templates
```

## License

MIT License. Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
