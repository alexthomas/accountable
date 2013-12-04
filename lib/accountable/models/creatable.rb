module Accountable
  module Models
    module Creatable
      extend ActiveSupport::Concern
      included do
        extend Accountable::Users::ProfileHelpers, Accountable::Users::AccessibleHelpers,Accountable::SearchHelpers                    
       
      end
      
      module ClassMethods
        # Videoable::Models.config(self)
      end
      
    end
    end
    
  end
  
end