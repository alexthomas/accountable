Rails.application.routes.draw do

  resources :accounts
  root :to => "test#index"
end
