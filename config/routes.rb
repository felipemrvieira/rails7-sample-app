Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      # get 'sectors/emissions', to: 'sectors#emissions'
      resources :emissions, only: [:index]
      resources :gases, only: [:index]
      resources :territories, only: [:index]
    end
  end


end
