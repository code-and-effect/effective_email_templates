module Admin
  class EmailTemplatesController < ApplicationController
    before_filter :authenticate_user!   # This is devise, ensure we're logged in.

    layout (EffectiveEmailTemplates.layout.kind_of?(Hash) ? EffectiveEmailTemplates.layout[:admin_email_templates] : EffectiveEmailTemplates.layout)

    def index
      @datatable = Effective::Datatables::EmailTemplates.new() if defined?(EffectiveDatatables)
      @page_title = 'Email Templates'

      EffectiveEmailTemplates.authorized?(self, :index, Effective::EmailTemplate)
    end

    def show
      @email_template = Effective::EmailTemplate.find(params[:id])
      @page_title = "Show"

      EffectiveEmailTemplates.authorized?(self, :show, @email_template)
    end

  end
end
