module Accountable
  module Accounts   
    class UsersController < ApplicationController
      before_filter :set_body_id
      before_filter :set_profile_field_names, :only => ['new','edit','create','update']
      
      def set_body_id
        @body_id = "users"
      end
      
      def index
        
      end
      
    end
  
  end
end