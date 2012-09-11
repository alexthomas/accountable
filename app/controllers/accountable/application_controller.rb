module Accountable
  class ApplicationController < ActionController::Base
    
    protect_from_forgery
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_path, :alert => exception.message
    end
      
    def set_profile_field_names(klass=nil)
      klass ||= controller_klass
      @pf_names = {}
      return if !klass.constantize.respond_to?(:profile_field_names)
      @pf_names = klass.constantize.profile_field_names
      logger.debug "pf names #{@pf_names.inspect}"
    end
  end
end
