require 'spec_helper'

describe LiquidResolvedMailer do

  describe 'basic template resolution and rendering' do
    before :each do
      @email_body = 'liquid resolution!'
      @template = create(:email_template, slug: 'test_email', body: @email_body)
      @mail = LiquidResolvedMailer.test_email
    end

    it 'creates emails using a liquid template' do
      expect(@mail.body.to_s).to eq(@email_body)
    end
  end

  describe 'embedded template resolution and rendering' do
    it 'correctly renders emails using an embedded liquid template' do
      @email_body = 'liquid {{ noun }}!'
      @renderred_body = 'liquid resolution!'
      @template = create(:email_template, slug: 'test_email', body: @email_body)
      @mail = LiquidResolvedMailer.test_email
      expect(@mail.body.to_s).to eq(@renderred_body)
    end

    it 'renders emails with nested variables' do
      @email_body = 'liquid {{ noun.for_the_new_year }}!'
      @renderred_body = 'liquid resolution!'
      @template = create(:email_template, slug: 'test_email', body: @email_body)
      @mail = LiquidResolvedMailer.test_email({
        'noun' => {
          'for_the_new_year' => 'resolution'
        }
      })
      expect(@mail.body.to_s).to eq(@renderred_body)
    end
  end
end

