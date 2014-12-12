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
          post :create, effective_email_template: attributes_for(:email_template), :use_route => :effective_email_templates
        }.to change(Effective::EmailTemplate,:count).by(1)
      end
    end

    context "member actions" do
      before :each do
        @email_template = create(:email_template)
      end

      describe "#edit" do
        it 'opens' do
          get :edit, :id => @email_template.id, :use_route => :effective_email_templates
          expect(response.status).to eq 200
        end
      end

      describe "#update" do
        it 'updates an email template' do
          attributes = @email_template.attributes
          old_from = @email_template.from
          new_from = "gfssljewr@dsfa.com"
          attributes["from"] = new_from
          expect{
            patch :update, id: @email_template.id, effective_email_template: attributes, :use_route => :effective_email_templates
            @email_template.reload
          }.to change(@email_template,:from)
        end
      end
    end

  end
end

