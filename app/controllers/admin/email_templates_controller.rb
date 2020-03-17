module Admin
  class EmailTemplatesController < ApplicationController
    before_action :authenticate_user! if respond_to?(:authenticate_user!)

    layout (EffectiveEmailTemplates.layout.kind_of?(Hash) ? EffectiveEmailTemplates.layout[:admin_email_templates] : EffectiveEmailTemplates.layout)

    def index
      @datatable = EffectiveEmailTemplatesDatatable.new
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
        flash[:success] = 'Successfully created email template'
        redirect_to effective_email_templates.admin_email_templates_path
      else
        flash.now[:danger] = 'Unable to create email template'
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
        flash[:success] = 'Successfully updated email template'
        redirect_to effective_email_templates.admin_email_templates_path
      else
        flash.now[:danger] = 'Unable to update email template'
        render :edit
      end
    end

    def destroy
      @email_template = Effective::EmailTemplate.find(params[:id])

      authorize_effective_email_templates!

      if @email_template.destroy
        flash[:success] = 'Successfully deleted email template'
      else
        flash[:danger] = 'Unable to delete email template'
      end

      redirect_to effective_email_templates.admin_email_templates_path
    end

    private

    def authorize_effective_email_templates!
      EffectiveEmailTemplates.authorize!(self, :admin, :effective_email_templates)
      EffectiveEmailTemplates.authorize!(self, action_name.to_sym, @email_template || Effective::EmailTemplate)
    end

    def email_template_params
      params.require(:effective_email_template).permit(EffectiveEmailTemplates.permitted_params)
    end

  end
end
