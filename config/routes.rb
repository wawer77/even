Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:show]  
 
  resources :balances

  resources :transactions do
    member do
      get :confirm
    end
  end

  resources :friendships do
    member do
      get :confirm
    end
  end
  get '/home' => "static#logged_in_landing", :as => :home
  root 'static#landing'
end
