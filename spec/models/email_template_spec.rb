require 'spec_helper'

describe Effective::EmailTemplate do
  before :each do
    @email = create(:email_template)
  end

  it 'should be persisted' do
    expect(@email.persisted?).to be(true)
  end

  it 'can be valid without a template explicitly stored' do
    email = build(:email_template, template: nil)
    expect(email).to be_valid
  end

  it 'stores a template after precompiling' do
    email = build(:email_template)

    # The initial template is an empty liquid template provided by the ::serialize method
    expect(email.template.render).to be_blank

    email.precompile

    expect(email.template.render).not_to be_blank
  end

  it 'stores a precompiled template' do
    expect(@email.template).to be_a(Liquid::Template)
  end

  it 'knows how to render itself' do
    expect(@email.render).to be_a(String)
  end

  it 'does not precompile if the body has not changed' do
    @email.from = 'other@example.com'
    expect(Liquid::Template).to_not receive(:parse).with(@email.body)
    @email.save
  end

  it 'does precompile if the body has changed' do
    @email.body = 'Hello World -- changed'
    parsed_template = Liquid::Template.parse(@email.body)
    expect(Liquid::Template).to receive(:parse).with(@email.body).and_return(parsed_template)
    @email.save
  end
end

