Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: [:show]
  resources :transactions, :balances
  root 'static#landing'
end
