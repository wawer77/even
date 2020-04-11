Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :transactions
  root 'static#landing'
end
