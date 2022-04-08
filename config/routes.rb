Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      get 'emission_uploads/per_sector'
      resources :emission_uploads
      resources :emissions, only: [:index, :create]
      resources :gases, only: [:index]
      resources :territories, only: [:index]
      resources :sectors, only: [:index]
      resources :emission_types, only: [:index]

      get 'territories/search_city', to: 'territories#search_city'
      
      resource :total_emission, only: [:show] do
        get 'emission', defaults: { format: 'json' }
        get 'consolidated_per_year'
      end
      
      mount_devise_token_auth_for 'Admin', at: 'auth', controllers: {
        # confirmations:      'devise_token_auth/confirmations',
        # passwords:          'devise_token_auth/passwords',
        # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
        registrations:        'api/v1/admins/registrations',
        sessions:             'api/v1/admins/sessions',
        # token_validations:  'devise_token_auth/token_validations'
      }

    end
  end


end
