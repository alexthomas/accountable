class Account < ActiveRecord::Base
  
  belongs_to :plan
  belongs_to :owner, :class_name => 'User',  :foreign_key => :owner_id
  has_many :members, :class_name => 'User', :foreign_key => :account_id
  has_one :confirmation_invite, :class_name => 'Invite', :as => :inviteable, :dependent => :destroy
  
  accepts_nested_attributes_for :owner 
  
  validates :plan,      :presence => true
  validates :confirmation_code, :invite_code  => { :association => 'confirmation_invite', :allow_nil => false },
                          :if => lambda { |account| account.account_status == -1 && account.confirming}
  
  attr_accessor :confirmation_code,:confirming
  attr_accessible :owner_attributes,:account_status,:confirmation_code,:confirming
  
  before_save  :confirm_account
  after_create :send_confirmation_email
  
  def send_confirmation_email
    logger.debug "enquing account confirmation email #{self.account_status}"
    Resque.enqueue(Emailer, self.owner.class.name,self.owner.id,'confirm_account') if self.account_status !=1
  end
  
  def confirm_account
    if !self.confirmation_code.nil? && self.account_status == -1 && !self.confirmation_invite.nil?
      self.account_status = 1
      self.confirmation_invite.activated_date = Time.now if !self.confirmation_invite.nil?
      self.confirmation_invite.activated = true
    end
    
  end
  
end
