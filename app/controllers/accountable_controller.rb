class AccountableController < Accountable.parent_controller.constantize
    
  protect_from_forgery
  
  before_filter do
    filter_params_method = "#{resource_name}_params"
    params[resource_name.to_sym] = send(filter_params_method) if respond_to?(filter_params_method, true)  
  end
  
  def restrict_params_to(*permitted_params)
    restricted_params = params[resource_name.to_sym]
    if params && params[resource_name.to_sym].kind_of?(Hash)
      restricted_params = params.require(resource_name.to_sym).permit(permitted_params)
    end
    restricted_params
  end
  
  def resource_name
    controller_name.classify.downcase
  end
  
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
