require 'spec_helper'

describe User do
  it 'sends an email after creation' do
    expect {
      create(:user)
    }.to change { ActionMailer::Base.deliveries.length }.by(1)
  end
end

