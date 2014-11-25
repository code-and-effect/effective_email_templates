Rails.application.routes.draw do
  mount EffectiveEmailTemplates::Engine => '/', :as => 'effective_email_templates'
end

EffectiveEmailTemplates::Engine.routes.draw do
  scope :module => 'effective' do
    resources :email_templates
    # Gets or Matches or whatever here
  end

  if defined?(EffectiveDatatables)
    namespace :admin do
      resources :email_templates
    end
  end

end
