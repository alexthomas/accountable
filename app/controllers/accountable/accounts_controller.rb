module Accountable
  
  class AccountsController < ApplicationController
    #load_and_authorize_resource
    before_filter :get_plan, :only => ['new']
    before_filter :set_profile_field_names, :only => ['new','edit','create','update']
   
    def index
      Account.find(:all).paginate(:page => params[:page])
    end
  
    def show
      @account = Account.find params[:id]
    end
  
    def new
      @account = Account.new
      logger.debug "inspecting profile fields names #{@pf_names.inspect}"
      @account.plan = @plan
      @account.build_owner
    end
  
    def create
      @account = Account.new params[:account]
      @account.plan = @plan
      @account.owner.assigned_roles.build :role_id => 3
      @account.owner.assigned_groups.build :group_id => 1
      
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
      @account = Account.new
      @user = @account.owner
      @confirmation_code = params[:cc]
      @confirmation_code = session[:cc] if !@confirmation_code && session[:cc]
      @account.account_status > 0 ? render('show') : render('edit')
    end
    
    def edit
    
    end
  
    def update 
      @account = Account.find params[:id]
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


