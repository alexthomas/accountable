module Accountable
  module Accounts   
    class UsersController < AccountableController
      load_and_authorize_resource
      before_filter :is_confirmed?, :only => [:confirm]
      before_filter :have_confirmation_code?, :only => [:confirm]
      before_filter :set_body_id
      before_filter :set_profile_field_names, :only => [:new,:edit,:create,:update]
      before_filter :get_account
      before_filter :can_add_user_check, :only => [:new,:create]
      


      def set_body_id
        @body_id = "users"
      end

      def index
       @users = User.accessible_by(current_ability).paginate(:page => params[:page])
      end

      def show
        @user = User.find params[:id]
      end

      def edit
        #allow active users with permission (determined by cancan to edit users)
        render("edit")
      end

      def update

        if @user.update_attributes params[:user]
          #redirect_to @user
          #@upf_names = User.profile_field_names
          @success = true;
          redirect_to @user
        else
          #set_profile_field_names
          session[:form_errors] = generate_errors([@user])
          @success = false;
          @user.user_status < 0 && !current_user ? render("confirm") : render('edit')

        end

      end

      def new
        @user = User.new
      end

      def create
        @user = User.new params[:user]
        @user.moa = @account
        @user.user_status = -1 #users created through accounts dont require pwds until confirm
        if @user.save
          flash[:success] = "User successfully added"
          #redirect_to instance_variable_get("@#{@user_type}")
          redirect_to @user
        else
          session[:form_errors] = generate_errors([@user])
          render :new

        end

      end

      def confirm
        edit if @user.user_status > 0
      end

      def destroy
        #@user = User.find params[:id]
        @user ||= nil
        @destroy_is_current = (@user.id == current_user.id) ? true : false
        @user.destroy unless @user == nil
        sign_out if @destroy_is_current
        redirect_to dashboard_url
      end

      private 

      def get_account
        @account = current_user.account
      end
      
      def can_add_user_check
        #check user has account where they can add users and if they have 
        #any user spaces left
        if !Plan.can_add_user(current_user)
          flash[:failure] = "Sorry you can't add any more users on your plan"
          redirect_to @account
        end
      end
      
      def is_confirmed?
        redirect_to(@user) if @user.is_confirmed?
      end
      
      def have_confirmation_code?
        @invite_code = params[:ic] if defined?(params[:ic])
        @invite_code = session[:ic] if @invite_code.nil? && session[:ic]
        if @invite_code.nil?
          flash[:failure] = 'A confirmation code required to confirm a user'
          redirect_to('index') 
        end
        
      end


    end
  end
end