

Rails.application.routes.draw do
  #get "users" => "accountable/accounts/users#index"
  
  scope :module => 'accountable' do
    resources :accounts

    scope :module => 'accounts' do
      resources :plans, :only => [:index]
      devise_for :users, :module => "devise"
      resources :users, :only => [:show, :index] do
        member do
          get 'confirm'

        end
      end
    end
  end
  
end


