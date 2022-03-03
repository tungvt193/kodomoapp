Rails.application.routes.draw do
  mount ApplicationApi, at: "/api"
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  namespace :admins do 
    root to: 'dashboards#index'
  end
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
