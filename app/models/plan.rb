class Plan < ActiveRecord::Base
  
  has_many :subscriptions, :class_name => 'Account',  :foreign_key => :plan_id
  
  scope :private, :conditions => { :private => true }
  scope :public, :conditions => { :private => false }
  
  attr_accessible :name,:description,:max_users,:max_groups,:max_events,:max_active_events,:max_event_days,:price,:private
  
end
