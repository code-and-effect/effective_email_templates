require 'spec_helper'

describe User do
  it 'sends an email after creation' do
    create(:email_template, slug: :after_create_user)
    expect {
      create(:user)
    }.to change { ActionMailer::Base.deliveries.length }.by(1)
  end
end
