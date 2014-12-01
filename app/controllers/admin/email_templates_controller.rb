module Admin
  class EmailTemplatesController < ApplicationController
    before_filter :authenticate_user!   # This is devise, ensure we're logged in.

    layout (EffectiveEmailTemplates.layout.kind_of?(Hash) ? EffectiveEmailTemplates.layout[:admin_email_templates] : EffectiveEmailTemplates.layout)

    def index
      EffectiveEmailTemplates.authorized?(self, :index, Effective::EmailTemplate)

      @datatable = Effective::Datatables::EmailTemplates.new() if defined?(EffectiveDatatables)
      @page_title = 'Email Templates'
    end

    def show
      @email_template = Effective::EmailTemplate.find(params[:id])
      EffectiveEmailTemplates.authorized?(self, :show, @email_template)

      @page_title = "Show"
    end

    def new
      @email_template = Effective::EmailTemplate.new
      EffectiveEmailTemplates.authorized?(self, :new, @email_template)
    end

    def create
      @email_template = Effective::EmailTemplate.new(email_template_params)
      EffectiveEmailTemplates.authorized?(self, :create, @email_template)

      if @email_template.save
        flash[:success] = "Email template created successfully"
        redirect_to effective_email_templates.admin_email_templates_path
      else
        flash.now[:error] = "Could not create email template"
        render :new
      end
    end

    def edit
      @email_template = Effective::EmailTemplate.find(params[:id])
      EffectiveEmailTemplates.authorized?(self, :edit, @email_template)
    end

    def update
      @email_template = Effective::EmailTemplate.find(params[:id])
      EffectiveEmailTemplates.authorized?(self, :update, @email_template)

      if @email_template.update(email_template_params)
        flash[:success] = "Email template updated successfully"
        redirect_to effective_email_templates.admin_email_templates_path
      else
        flash.now[:error] = "Could not update email template"
        render :edit
      end
    end

    private

    def email_template_params
      params.require(:effective_email_template).permit([ :from, :cc, :bcc, :subject, :body, :slug ])
    end
  end
end
