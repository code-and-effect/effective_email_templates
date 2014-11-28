require 'spec_helper'

describe EffectiveEmailTemplates do
  it 'finds templates by their slug' do
    template = create(:email_template, slug: 'a_unique_email_template_identifier')
    expect(
      EffectiveEmailTemplates.get(:a_unique_email_template_identifier)
    ).to eq( template )
  end
end
