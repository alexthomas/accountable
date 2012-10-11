class ProfileField < ActiveRecord::Base
    has_many :active_fields, :dependent => :destroy
    has_many :profiles, :through => :active_fields
  
    attr_accessible :name,:var_type,:input_type
end
