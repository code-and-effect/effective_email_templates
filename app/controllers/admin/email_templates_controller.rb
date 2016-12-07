module Admin
  class EmailTemplatesController < ApplicationController
    before_filter :authenticate_user!   # This is devise, ensure we're logged in.

    layout (EffectiveEmailTemplates.layout.kind_of?(Hash) ? EffectiveEmailTemplates.layout[:admin_email_templates] : EffectiveEmailTemplates.layout)

    def index
      @datatable = Effective::Datatables::EmailTemplates.new()
      @page_title = 'Email Templates'

      authorize_effective_email_templates!
    end

    def new
      @email_template = Effective::EmailTemplate.new
      @page_title = 'New Email Template'

      authorize_effective_email_templates!
    end

    def create
      @email_template = Effective::EmailTemplate.new(email_template_params)
      @page_title = 'New Email Template'

      authorize_effective_email_templates!

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
      @page_title = 'Edit Email Template'

      authorize_effective_email_templates!
    end

    def update
      @email_template = Effective::EmailTemplate.find(params[:id])
      @page_title = 'Edit Email Template'

      authorize_effective_email_templates!

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
      params.require(:effective_email_template).permit([ :from, :cc, :bcc, :subject, :body ])
    end

    def authorize_effective_email_templates!
      EffectiveEmailTemplates.authorized?(self, :admin, :effective_email_templates)
      EffectiveEmailTemplates.authorized?(self, action_name.to_sym, @email_template || Effective::EmailTemplate)
    end

  end
end
