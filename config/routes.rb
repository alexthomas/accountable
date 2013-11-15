Accountable::Engine.routes.draw do
  # resources :accounts
  root :to => "accounts#index"
  devise_for :users,:module => "devise", :only => [:passwords]
end
