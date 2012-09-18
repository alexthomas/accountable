module Accountable
  module Accounts   
    class UsersController < AccountableController
      load_and_authorize_resource
      before_filter :is_confirmed?, :only => [:confirm]
      before_filter :set_body_id
      before_filter :set_profile_field_names, :only => ['new','edit','create','update']


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
          @user.user_status > 0 ? render("edit") : render('confirm')

        end

      end

      def new
        @user = User.new
      end

      def create
        @user = User.new params[:user]
        @user.moa = User.first.account
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
        @invite_code = params[:ic]
        edit if @user.user_status == 0
      end

      def destroy
        #@user = User.find params[:id]
        @user ||= nil
        @destroy_is_current = (@user.id == current_user.id) ? true : false
        @user.destroy unless @user == nil
        sign_out if @destroy_is_current
      end

      private 

      def get_account
        #check user has account where they can add users anf if they have 
        #any user spaces left
        if !Plan.can_add_user(current_user)
          flash[:failure] = "Sorry you can't add any more users on your plan"
          redirect_to current_user.account 
        end
      end

      def is_confirmed?
        redirect_to(@user) if @user.is_confirmed?
      end


    end
  end
end