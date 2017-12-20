Rails.application.routes.draw do


  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    registrations: "registrations",
    passwords: "passwords"
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :performances

  resources :users, only: [:performances] do
    resources :performances, module: :users, only: [:index, :show, :update]
  end

  resources :ranking, only: [:index]
  resources :matches, only: [:create, :index, :update, :approve] do
    member do
      post :approve
    end
  end


  resource :base_infos, only: [:current_user] do
    get :actual_user
  end

  get '/authorizations/:object(/:id)/:auth_action' => 'authorizations#check', as: 'authorization_request'


  root to: 'dashboard#main'
end
