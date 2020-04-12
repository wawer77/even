Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :transactions, :balances
  root 'static#landing'
end
