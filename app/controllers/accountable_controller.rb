class AccountableController < Accountable.parent_controller.constantize
    
  protect_from_forgery
  def generate_errors(models)
  	errors = Array.new 

    models.each do | model |

      if model.errors.any?
        model.errors.full_messages.each do |msg|
    	     errors << msg #push msg onto errors array 
  	     end
      end
    end

    errors  
  end
    
  def set_profile_field_names(klass=nil)
    klass ||= controller_klass
    @pf_names = {}
    return if !klass.constantize.respond_to?(:profile_field_names)
    @pf_names = klass.constantize.profile_field_names
    logger.debug "pf names #{@pf_names.inspect}"
  end

  def controller_klass
      controller_klass = self.class.name.split(':').last.sub("Controller", "").singularize
  end
end
