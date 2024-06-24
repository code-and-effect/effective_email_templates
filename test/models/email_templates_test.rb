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
    assert mail.body.to_s.start_with?("Welcome #{user.first_name} #{user.last_name}")
    assert_equal 'info@example.com', mail.from.first
  end

  test 'welcome with overridden content' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    ApplicationMailer.welcome(user, subject: "Hello #{user.first_name}", body: "Hey #{user.first_name}").deliver_now
    mail = ActionMailer::Base.deliveries.last

    assert_equal "Hello #{user.first_name}", mail.subject
    assert mail.body.to_s.start_with?("Hey #{user.first_name}")
  end

  test 'welcome with mailer subject proc' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    with_mailer_subject_proc { ApplicationMailer.welcome(user).deliver_now }
    mail = ActionMailer::Base.deliveries.last

    assert_equal "[EFFECTIVE] Welcome #{user.first_name} #{user.last_name}", mail.subject
    assert mail.body.to_s.start_with?("Welcome #{user.first_name} #{user.last_name}")
  end

  test 'welcome with overridden duplicate mailer subject proc content' do
    email_template = build_effective_email_template()
    email_template.save!

    user = build_user()
    user.save!

    with_mailer_subject_proc do
      ApplicationMailer.welcome(user, subject: "[EFFECTIVE] Hello #{user.first_name}", body: "Hey #{user.first_name}").deliver_now
    end

    mail = ActionMailer::Base.deliveries.last

    assert_equal "[EFFECTIVE] Hello #{user.first_name}", mail.subject
    assert mail.body.to_s.start_with?("Hey #{user.first_name}")
  end

  test 'plain emails cannot have <p> or </div>' do
    email_template = build_effective_email_template()
    assert email_template.plain?
    assert email_template.valid?

    refute email_template.update(body: "<p>Hello</p>")
    refute email_template.update(body: "<div>Hello</div>")
    assert email_template.update(body: "<a href='http://www.slashdot.org>Slashdot.org</a>")
  end

  test 'html emails must have <p> or </div>' do
    email_template = build_effective_email_template()

    assert email_template.update(content_type: 'text/html', body: "<p>Hello</p>")
    assert email_template.update(body: "<div>Hello</div>")
    refute email_template.update(body: "Hello")
  end

  test 'save_as_html! with br' do
    email_template = build_effective_email_template()

    assert email_template.plain?
    assert_equal "Welcome {{ user.first_name }} {{ user.last_name }}\r\nHave a great day!", email_template.body

    email_template.save_as_html!

    assert email_template.html?
    assert_equal "<p>Welcome {{ user.first_name }} {{ user.last_name }}\n<br />Have a great day!</p>", email_template.body
  end

  test 'save_as_html! with line breaks' do
    email_template = build_effective_email_template()
    email_template.update!(body: "Welcome {{ user.first_name }} {{ user.last_name }}\n\nHave a great day!")
    email_template.save_as_html!

    assert email_template.html?
    assert_equal "<p>Welcome {{ user.first_name }} {{ user.last_name }}</p>\n\n<p>Have a great day!</p>", email_template.body
  end

  test 'save_as_plain!' do
    email_template = build_effective_email_template()
    email_template.update!(content_type: 'text/html', body: "<p>Welcome {{ user.first_name }} {{ user.last_name }}</p>\n\n<p>Have a great day!</p>")
    email_template.save_as_plain!

    assert email_template.plain?
    assert_equal "Welcome {{ user.first_name }} {{ user.last_name }}\n\nHave a great day!", email_template.body
  end

  test 'welcome html email' do
    email_template = build_effective_email_template()
    email_template.save_as_html!

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
    assert_equal "<!DOCTYPE html>\n<html style='background: #fff;'>\n<head>\n<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>\n</head>\n<body style='background: #fff;'>\n<p>Hey Test</p>\n</body>\n</html>\n", html.body.to_s

    # Plain Part (strip tags)
    plain = mail.parts.find { |part| part.content_type.start_with?('text/plain') }
    assert_equal "Hey Test\n", plain.body.to_s
  end

  test 'plain text emails with html content should raise error' do
    email_template = build_effective_email_template()
    email_template.save!
    assert email_template.plain?

    user = build_user()
    user.save!

    expected_error = begin
      ApplicationMailer.welcome(user, subject: "Hello #{user.first_name}", body: "<p>Hey #{user.first_name}</p>").deliver_now
    rescue => e
      e.message
    end

    assert_equal 'unexpected html content found when when rendering text/plain email_template welcome', expected_error
  end

end
