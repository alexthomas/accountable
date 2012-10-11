class Group < ActiveRecord::Base
    has_many :assigned_groups
    has_many :users, :through => :assigned_groups
  
    attr_accessible :name,:description
end