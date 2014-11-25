module Effective
  class EmailTemplatesController < ApplicationController
    layout (EffectiveEmailTemplates.layout.kind_of?(Hash) ? EffectiveEmailTemplates.layout[:email_templates] : EffectiveEmailTemplates.layout)

    def index
    end

  end
end
