Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:show]  
 
  resources :transactions, :balances

  resources :friendships do
    member do
      get :confirm
    end
  end

  root 'static#landing'
end
