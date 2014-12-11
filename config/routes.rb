Rails.application.routes.draw do
  mount EffectiveEmailTemplates::Engine => '/', :as => 'effective_email_templates'
end

EffectiveEmailTemplates::Engine.routes.draw do
  if defined?(EffectiveDatatables)
    namespace :admin do
      resources :email_templates, only: [:index, :new, :create, :edit, :update]
    end
  end
end
