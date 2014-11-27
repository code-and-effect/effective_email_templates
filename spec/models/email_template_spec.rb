require 'spec_helper'

describe Effective::EmailTemplate do
  it 'stores a precompiled template' do
    email = build(:email_template)
    expect(email.template).to eq(nil)

    email.precompile

    expect(email.template).not_to be(nil)
  end

  it 'loads a precompiled template' do
    email = create(:email_template)
    expect(Marshal.load(email.template)).to be_a(Liquid::Template)
  end

  it 'knows how to render itself' do
    email = create(:email_template)
    expect(email.render).to be_a(String)
  end

  it 'raises an error if a user attempts to set the template attribute directly' do
    email = build(:email_template)
    expect {
      email.template = email.body
    }.to raise_exception(Effective::RestrictedAttributeAccess)
  end
end
