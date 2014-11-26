require 'spec_helper'

describe Admin::EmailTemplatesController do
  context "as an admin" do
    before :each do
      @admin = create(:admin)
      sign_in @admin
    end

    describe "#index" do
      it 'opens' do
        get :index, :use_route => :effective_email_templates
        expect(response.status).to eq 200
      end
    end
  end
end
