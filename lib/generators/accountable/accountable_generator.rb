module Accountable
  module Generators
    class AccountableGenerator < Rails::Generators::NamedBase
      argument :arguments, :type => :hash, :default => {}
      include Rails::Generators::ResourceHelpers

      namespace "accountable"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with devise " <<
           "configuration plus a migration file and devise routes."
    
      def accountable
        say("options: #{arguments}")
      end
      
      hook_for :orm

      
      def add_accountable_routes
        options.routes? ? say("we have routes") : say("we have no routes")
        route "resources :accounts" if arguments.routes?
        
        account_routes = <<-ROUTE
        scope module: 'accountable' do
          resources :accounts
          resources :plans, :only => :index
        end
        ROUTE
        route account_routes if arguments.routes?
      end
      
      def add_devise_routes
        devise_route = 
<<-ROUTE
devise_scope :#{class_name} do
  get "sign_in", :to => "devise/sessions#new", :as => 'new_#{name}_session'
  post "sign_in", :to => "devise/sessions#create", :as => '#{name}_session'
  delete "sign_out", :to => "devise/sessions#destroy", :as => 'destroy_#{name}_session'
end
ROUTE
        route devise_route  if arguments.routes?
      end

    end
  end
end