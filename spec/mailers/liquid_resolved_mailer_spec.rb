require 'spec_helper'

describe LiquidResolvedMailer do
  let(:email_body) { 'liquid resolution!' }
  let(:email_title) { :test_email }

  before :each do
    @template = create(:email_template, slug: email_title, body: email_body)
  end

  it 'creates emails using a liquid template' do
    mail = LiquidResolvedMailer.send(email_title)
    expect(mail.body.to_s).to eq(email_body)
  end
end

