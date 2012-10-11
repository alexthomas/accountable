Rails.application.routes.draw do
  scope :module => 'accountable' do
    match '/signup/plans', :controller => 'accounts/plans', :action =>'index'
    resources :accounts
  
  end

end