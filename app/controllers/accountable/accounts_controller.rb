module Accountable
  
  class AccountsController < AccountableController
    skip_authorize_resource :only => [:new,:create ]
    before_filter :get_plan, :only => [:new,:create]
    before_filter :only => ['new','edit','create','update'] do | controller |
      controller.set_profile_field_names('User')
    end
    load_and_authorize_resource
    
    def index
      Account.accessible_by(current_ability).paginate(:page => params[:page])

    end
  
    def show
      #redirect_to dashboard_url
    end
  
    def new
      # @account = Account.new
      logger.debug "inspecting profile fields names #{@pf_names.inspect}"
      @account.plan = @plan
      @account.build_owner
    end
  
    def create
      @account = Account.new account_params
      @account.plan = @plan

      @account.owner.assigned_roles.build :role_id => 3
      @account.owner.assigned_groups.build :group_id => 1
      @account.owner.user_status = 0
      @account.members << @account.owner if @account.owner.valid?
      
      if @account.save
        flash[:success] = "Account Successfully created"
        sign_in @account.owner
        redirect_to @account

      else
        session[:form_errors] = generate_errors([@account])
        logger.debug "inspecting owner profile #{@account.owner.profile.inspect}"
        logger.debug "errors in creation: #{session[:form_errors]}"
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
      if @account.update_attributes account_params
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
        Rails.logger.debug "singup plan id session #{session[:signup_plan_id]}"
        begin
          @plan = Plan.find plan_id
          logger.debug "inspecting plan in get plan #{@plan.inspect}"
          session[:signup_plan_id] = @plan.id
        rescue ActiveRecord::RecordNotFound
        
          session[:errors] = "Sorry could not find Plan"
          redirect_to plans_path
        end
      
      end
      # "account"=>{"owner_attributes"=>{"profile_attributes"=>{"name"=>"",
      #      "photo_attributes"=>{"asset_url"=>""}},
      #      "email"=>"",
      #      "password"=>"[FILTERED]",
      #      "password_confirmation"=>"[FILTERED]"}},
      #      "commit"=>"new Account"}
      #     
      def is_confirmed?
        redirect_to(@account) if @account.is_confirmed?
      end
      
      def account_params
        restrict_params_to(:account_status,:confirmation_code,:confirming, owner_attributes: [:name, :email, :password, :password_confirmation, :remember_me,:user_status,
                          :invite_code,:confirming,profile_attributes: [:name, photo_attributes: [:title, :description, :attachment, 
                          :attachment_file_name, :attachment_content_type, :attachment_file_size,:asset_url,:asset_remote_url,:metadata,:attachment],
                          active_fields_attributes: [:profile_field_id,:value,:publik]], role_attributes: [:name], 
                          group_attributes: [:name,:description],invite_attributes: [:invitee_id,:invite_code, :activated, :invite_date, :activated_date]])
      end
  end
end

# def account_params
#   params.require(:account).permit(:account_status,:confirmation_code,:confirming, owner_attributes: [:name, :email, :password, :password_confirmation, :remember_me,:user_status,
#   :invite_code,:confirming,profile_attributes: [:name, photo_attributes: [:title, :description, :attachment, 
#   :attachment_file_name, :attachment_content_type, :attachment_file_size,:asset_url,:asset_remote_url,:metadata,:attachment],
#   active_fields_attributes: [:profile_field_id,:value,:publik]], role_attributes: [:name], 
#   group_attributes: [:name,:description],invite_attributes: [:invitee_id,:invite_code, :activated, :invite_date, :activated_date]])
# end


