require 'spec_helper'

describe "FactoryGirl Factories" do
  let(:factories) { [ :user, :email_template ] }

  it "has factories that are valid" do
    factories.each { |f| FactoryGirl.create(f).valid?.should eq true }
  end
end

