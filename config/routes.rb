EffectiveEmailTemplates::Engine.routes.draw do
  namespace :admin do
    resources :email_templates
  end
end

Rails.application.routes.draw do
  mount EffectiveEmailTemplates::Engine => '/', as: 'effective_email_templates'
end
