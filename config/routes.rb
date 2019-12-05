Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :balances
  root 'static#landing'
end
