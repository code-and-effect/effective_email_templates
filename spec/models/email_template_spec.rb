require 'spec_helper'

describe Effective::EmailTemplate do
  it 'stores a precompiled template' do
    email = build(:email_template)
    email.template.should be(nil)

    email.precompile

    email.template.should_not be(nil)
  end

  it 'loads a precompiled template' do
    email = create(:email_template)
    Marshal.load(email.template).should be_a(Liquid::Template)
  end
end
