module Accountable
  
  class AccountsController < AccountableController
    load_and_authorize_resource
    skip_authorize_resource :only => [:new,:create ]
    before_filter :get_plan, :only => [:new,:create]
    before_filter :only => ['new','edit','create','update'] do | controller |
      controller.set_profile_field_names('User')
    end
   
    def index
      Account.accessible_by(current_ability).paginate(:page => params[:page])
    end
  
    def show
      
    end
  
    def new
      logger.debug "inspecting profile fields names #{@pf_names.inspect}"
      @account.plan = @plan
      @account.build_owner
    end
  
    def create
      @account = Account.new params[:account]
      @account.plan = @plan

      @account.owner.assigned_roles.build :role_id => 3
      @account.owner.assigned_groups.build :group_id => 1
      @account.owner.user_status = 0
      
      if @account.save
        flash[:success] = "Account Successfully created"
        sign_in @account.owner
        redirect_to @account

      else
        session[:form_errors] = generate_errors([@account])
        logger.debug "inspecting owner profile #{@account.owner.profile.inspect}"
        #@account.owner.profile.build_photo
        render 'new'
      end

    end
    
    def confirm
      @user = @account.owner
      @confirmation_code = params[:cc]
      @confirmation_code = session[:cc] if !@confirmation_code && session[:cc]
      @account.account_status > 0 ? render('show') : render('edit')
    end
    
    def edit
    
    end
  
    def update
      if @account.update_attributes params[:account]
        redirect_to @account
      else
        session[:form_errors] = generate_errors([@account])
        @success = false;
        @account.account_status > 0 ? render('edit') : render('confirm')
        
      end
    end
  
    def destroy
    
    end
    
    private
    
      def get_plan
        plan_id = params[:plan]
        plan_id = session[:signup_plan_id] if !plan_id && session[:signup_plan_id]
        begin
          @plan = Plan.find plan_id
          logger.debug "inspecting plan in get plan #{@plan.inspect}"
          session[:signup_plan_id] = @plan.id
        rescue ActiveRecord::RecordNotFound
        
          session[:errors] = "Sorry could not find Plan"
          redirect_to signup_plans_url
        end
      
      end
      
      def is_confirmed?
        redirect_to(@account) if @account.is_confirmed?
      end
  end
end


