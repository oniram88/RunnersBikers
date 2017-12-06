Rails.application.routes.draw do


  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    registrations: "registrations",
    passwords: "passwords"
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :performances

  resources :users, only: [:performances] do
    resources :performances
  end

  resources :ranking, only: [:index]


  namespace :api do
    crud :rankings
    # Mount OpenAPI specification for API
    mount_openapi_specification name: :default
  end

  # Mount Swagger UI documentation for API
  mount_openapi_documentation


  root to: 'dashboard#main'
end
