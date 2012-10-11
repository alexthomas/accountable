class Invite < ActiveRecord::Base
     belongs_to :inviteable, :polymorphic => true
     belongs_to :invitee,:class_name => 'User',:foreign_key => 'invitee_id'
     
     attr_accessible :invitee_id,:invite_code, :activated, :invite_date, :activated_date
end