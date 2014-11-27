require 'spec_helper'

describe "Using RSpec" do
  it "tests the truth" do
    expect(EffectiveEmailTemplates).to be_a(Module)
  end
end
