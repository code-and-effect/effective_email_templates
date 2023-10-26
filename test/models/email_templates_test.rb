require 'test_helper'

class EmailTemplatesTest < ActiveSupport::TestCase
  test 'is valid' do
    email_template = build_effective_email_template
    assert email_template.valid?
  end

  test 'welcome' do
    user = build_user()

    ApplicationMailer.welcome(user).deliver_now
    mail = ActionMailer::Base.deliveries.last

    assert_equal "Welcome #{user.first_name}", mail.subject

  end

end
