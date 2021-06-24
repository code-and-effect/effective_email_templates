module Admin
  class EmailTemplatesController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_email_templates) }

    include Effective::CrudController

    if (config = EffectiveEmailTemplates.layout)
      layout(config.kind_of?(Hash) ? config[:admin] : config)
    end

    submit :save, 'Save'
    submit :save, 'Save and Add New', redirect: :new

    def email_template_params
      params.require(:effective_email_template).permit!
    end

  end
end
