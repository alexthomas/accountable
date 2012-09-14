class AssignedGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  attr_accessible :group_id
end