require 'test_helper'

class EmailTemplatesTest < ActiveSupport::TestCase
  test 'is valid' do
    email_template = build_effective_email_template
    assert email_template.valid?
  end

  test 'mailer_froms' do
    assert_equal EffectiveEmailTemplates.mailer_froms, ['"Info" <info@example.com>', '"Admin" <admin@example.com>']
  end

  test 'welcome with default content' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    ApplicationMailer.welcome(user).deliver_now
    mail = ActionMailer::Base.deliveries.last

    assert_equal "Welcome #{user.first_name} #{user.last_name}", mail.subject
    assert_equal 'info@example.com', mail.from.first

    html = mail.parts.find { |part| part.content_type.start_with?('text/html') }
    assert html.body.to_s.include?("<p>Welcome #{user.first_name} #{user.last_name}</p>")
  end

  test 'welcome with overridden content' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    ApplicationMailer.welcome(user, subject: "Hello #{user.first_name}", body: "<p>Hey #{user.first_name}</p>").deliver_now
    mail = ActionMailer::Base.deliveries.last

    assert_equal "Hello #{user.first_name}", mail.subject

    html = mail.parts.find { |part| part.content_type.start_with?('text/html') }
    assert html.body.to_s.include?("<p>Hey #{user.first_name}</p>")
  end

  test 'welcome with mailer subject proc' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    with_mailer_subject_proc { ApplicationMailer.welcome(user).deliver_now }
    mail = ActionMailer::Base.deliveries.last

    assert_equal "[EFFECTIVE] Welcome #{user.first_name} #{user.last_name}", mail.subject

    html = mail.parts.find { |part| part.content_type.start_with?('text/html') }
    assert html.body.to_s.include?("<p>Welcome #{user.first_name} #{user.last_name}</p>")
  end

  test 'welcome with overridden duplicate mailer subject proc content' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    with_mailer_subject_proc do
      ApplicationMailer.welcome(user, subject: "[EFFECTIVE] Hello #{user.first_name}", body: "<p>Hey #{user.first_name}</p>").deliver_now
    end

    mail = ActionMailer::Base.deliveries.last

    assert_equal "[EFFECTIVE] Hello #{user.first_name}", mail.subject

    html = mail.parts.find { |part| part.content_type.start_with?('text/html') }
    assert html.body.to_s.include?("<p>Hey #{user.first_name}</p>")
  end

  test 'normalizes non-breaking spaces inside liquid tags on save' do
    email_template = build_effective_email_template()

    # A WYSIWYG editor round-trips "{{ user.first_name }}" into non-breaking spaces (entity or char),
    # which stops Liquid from parsing the variable. Leave an intentional &nbsp; in the prose alone.
    email_template.subject = 'Hi {{&nbsp;user.first_name&nbsp;}}'
    email_template.body = "<p>Hi&nbsp;{{ user.first_name }}, welcome</p>"
    email_template.save!
    email_template.reload

    # Inside the tags is cleaned; the prose &nbsp; is preserved
    assert_equal 'Hi {{ user.first_name }}', email_template.subject
    assert_equal '<p>Hi&nbsp;{{ user.first_name }}, welcome</p>', email_template.body

    # And it renders the variable now instead of blank
    rendered = email_template.render('user' => { 'first_name' => 'Sam' })
    assert_equal 'Hi Sam', rendered[:subject]
    assert rendered[:body].include?('Hi&nbsp;Sam, welcome')
  end

  test 'save_as_html! with br' do
    email_template = build_effective_email_template()
    email_template.update!(body: "Welcome {{ user.first_name }} {{ user.last_name }}\r\nHave a great day!")

    assert_equal "<p>Welcome {{ user.first_name }} {{ user.last_name }}\n<br />Have a great day!</p>", email_template.body
  end

  test 'save_as_html! with line breaks' do
    email_template = build_effective_email_template()
    email_template.update!(body: "Welcome {{ user.first_name }} {{ user.last_name }}\n\nHave a great day!")

    assert_equal "<p>Welcome {{ user.first_name }} {{ user.last_name }}</p>\n\n<p>Have a great day!</p>", email_template.body
  end

  test 'welcome html email' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    with_mailer_subject_proc do
      ApplicationMailer.welcome(user, subject: "[EFFECTIVE] Hello #{user.first_name}", body: "<p>Hey #{user.first_name}</p>").deliver_now
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal 2, mail.parts.length

    # Subject
    assert_equal "[EFFECTIVE] Hello #{user.first_name}", mail.subject

    # HTML Part (from template)
    html = mail.parts.find { |part| part.content_type.start_with?('text/html') }
    assert_equal "<!DOCTYPE html>\n<html>\n  <head>\n    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n    <style>\n      /* Email styles need to be inline */\n    </style>\n  </head>\n\n  <body>\n    <p>Hey Test</p>\n  </body>\n</html>\n", html.body.to_s

    # Plain Part (strip tags)
    plain = mail.parts.find { |part| part.content_type.start_with?('text/plain') }
    assert_equal "Hey Test\n", plain.body.to_s
  end

end
