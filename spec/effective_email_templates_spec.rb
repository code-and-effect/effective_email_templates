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
      it 'raises an exception' do
        expect{
          EffectiveEmailTemplates.get(:this_does_not_exist)
        }.to raise_error(Effective::MissingDbTemplate)
      end

      it 'gives a custom message to the exception based on the slug name' do
        begin
          EffectiveEmailTemplates.get(:this_does_not_exist)
          raise # just in case
        rescue => e
          expect(e.message).to eq("Could not find template with slug: this_does_not_exist")
        end
      end
    end
  end
end
