module Accountable
  module Accounts 
    class PlansController < ApplicationController

 
      def index
        @plans = Plan.public.paginate(:page => params[:page])
      end
    
      def new
      
      end
    
    end
  end
end
