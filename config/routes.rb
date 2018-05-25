Rails.application.routes.draw do


  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    registrations: "registrations",
    passwords: "passwords"
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'dashboard#main'
end
