Rails.application.routes.draw do

  devise_scope :User do
  get "sign_in", :to => "devise/sessions#new", :as => 'new_user_session'
  post "sign_in", :to => "devise/sessions#create", :as => 'user_session'
  delete "sign_out", :to => "devise/sessions#destroy", :as => 'destroy_user_session'
end

          scope module: 'accountable' do
          resources :accounts
          resources :plans, :only => :index
        end


end
