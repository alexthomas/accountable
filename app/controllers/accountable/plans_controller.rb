module Accountable
    class PlansController < AccountableController

 
      def index
        @plans = Plan.public.paginate(:page => params[:page])
      end
    
      def new
      
      end
      
      private
        def plan_params
          params.require(:plan).permit(:name,:description,:max_users,:max_groups,:max_events,:max_active_events,:max_event_days,:price,:private)
        end
        
    end
end
