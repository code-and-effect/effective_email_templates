require 'spec_helper'

describe Effective::EmailTemplate do

  it 'stores a template after precompiling' do
    email = build(:email_template)

    # The initial template is an empty liquid template provided by the ::serialize method
    expect(email.template.render).to be_blank

    email.precompile

    expect(email.template.render).not_to be_blank
  end

  it 'stores a precompiled template' do
    email = create(:email_template)
    expect(email.template).to be_a(Liquid::Template)
  end

  it 'knows how to render itself' do
    email = create(:email_template)
    expect(email.render).to be_a(String)
  end
end

