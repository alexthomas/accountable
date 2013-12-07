module Accountable
  class Plan < ActiveRecord::Base
  
      has_many :subscriptions, :class_name => 'Account',  :foreign_key => :plan_id
  
      scope :private, -> { where(private: true) }
      scope :public, -> { where(private: false) }
  
      # attr_accessible :name,:description,:max_users,:max_groups,:max_events,:max_active_events,:max_event_days,:price,:private
  
      def can_add_user user
        plan = user.account.plan
        can_add = plan.max_users == 0 || plan.max_users >= user.account.members.size
      end
  end
end
