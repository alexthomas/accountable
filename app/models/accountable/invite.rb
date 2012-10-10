module Accountable
  class Invite < ActiveRecord::Base
     belongs_to :inviteable, :polymorphic => true
     belongs_to :invitee,:class_name => 'User',:foreign_key => 'invitee_id'
  end
end