require 'spec_helper'

describe EffectiveEmailTemplates do
  describe '::get' do
    it 'finds templates by their slug' do
      template = create(:email_template, slug: 'a_unique_email_template_identifier')
      expect(
        EffectiveEmailTemplates.get(:a_unique_email_template_identifier)
      ).to eq( template )
    end

    context 'when the template does not exist' do
      before :each do
        @template = EffectiveEmailTemplates.get(:this_doesnt_exist)
      end

      it "returns a template object" do
        expect(@template).to be_a(Effective::EmailTemplate)
      end

      it 'returns a template object with a slug' do
        expect(@template.slug).to eq(:this_doesnt_exist)
      end

      it 'returns a template object without other attributes' do
        # The template automatically gets generated by Rail's ::serialize method but its an empty template
        expect(@template.template.render('')).to eq ''
        attributes = @template.attributes
        attributes.delete("slug")
        attributes.delete("template")
        expect(attributes.values.compact).to be_empty
      end
    end
  end
end
