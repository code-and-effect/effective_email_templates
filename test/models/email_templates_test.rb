require 'test_helper'

class EmailTemplatesTest < ActiveSupport::TestCase
  test 'is valid' do
    email_template = build_effective_email_template
    assert email_template.valid?
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

end
