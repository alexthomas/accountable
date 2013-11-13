class Role < ActiveRecord::Base
    has_many :assigned_roles
    has_many :users, :through => :assigned_roles
  
    # attr_accessible :name
end
