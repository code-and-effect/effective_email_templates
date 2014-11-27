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

    describe "#new" do
      it 'opens' do
        get :new, :use_route => :effective_email_templates
        expect(response.status).to eq 200
      end
    end

    describe "#create" do
      it 'creates an email template' do
        expect{
          post :create, email_template: attributes_for(:email_template), :use_route => :effective_email_templates
        }.to change(Effective::EmailTemplate,:count).by(1)
      end
    end
  end
end
