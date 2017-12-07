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
  resources :matches, only: [:create]


  root to: 'dashboard#main'
end
