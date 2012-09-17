




Rails.application.routes.draw do
  #get "users" => "accountable/accounts/users#index"

  scope :module => 'accountable' do
    
    match '/signup/plans', :controller => 'accounts/plans', :action =>'index'
    resources :accounts

    scope :module => 'accounts' do
      resources :plans, :only => [:index]
      devise_for :users, :module => "devise"
      #devise_for :users, :module => "devise"
      #get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      #put 'users' => 'devise/registrations#update', :as => 'user_registration'
      resources :users do
        member do
          get 'confirm'

        end
      end
    end
    
    
  end
  
end