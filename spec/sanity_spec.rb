require 'spec_helper'

describe "Using RSpec" do
  it "tests the truth" do
    EffectiveEmailTemplates.should be_a(Module)
  end
end
