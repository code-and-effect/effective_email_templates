require 'test_helper'

class EmailTemplatesTest < ActiveSupport::TestCase
  test 'is valid' do
    email_template = build_effective_email_template
    assert email_template.valid?
  end
end
