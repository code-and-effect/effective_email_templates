require 'spec_helper'

describe Effective::EmailTemplate do
  it 'stores a precompiled template' do
    some_email = Effective::EmailTemplate.new(attributes_for(:email_template))
    some_email.template.should be(nil)

    some_email.precompile

    some_email.template.should_not be(nil)
  end
end
