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
      EffectiveEmailTemplates.authorized?(self, :show, @email_template)

      @email_template = Effective::EmailTemplate.find(params[:id])
      @page_title = "Show"
    end

    def new
      EffectiveEmailTemplates.authorized?(self, :new, @email_template)

      @email_template = Effective::EmailTemplate.new
    end

    def create
      EffectiveEmailTemplates.authorized?(self, :create, @email_template)

      @email_template = Effective::EmailTemplate.new(email_template_params)
      @email_template.precompile

      if @email_template.save
        flash[:success] = "Email template created successfully"
        redirect_to effective_email_templates.admin_email_templates_path
      else
        flash[:error] = "Could not create email template"
        redirect_to effective_email_templates.new_admin_email_template_path
      end
    end

    private

    def email_template_params
      params.require(:email_template).permit([ :from, :cc, :bcc, :subject, :body ])
    end
  end
end
