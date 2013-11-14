class User < ActiveRecord::Base
    extend Accountable::Users::ProfileHelpers, Accountable::Users::AccessibleHelpers,Accountable::SearchHelpers
    has_many :assigned_roles, :dependent => :destroy
    has_many :roles, :through => :assigned_roles
  
    has_many :assigned_groups, :dependent => :destroy
    has_many :groups, :through => :assigned_groups
  
    has_one :profile, :as => :profileable, :dependent => :destroy
    has_one :account, :foreign_key => :owner_id, :dependent => :destroy
    has_one :invite, :as => :inviteable, :dependent => :destroy
  
    belongs_to :moa,:class_name => 'Account',:foreign_key => 'account_id' #member of account
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable

    attr_accessor :invite_code, :confirming
    # Setup accessible (or protected) attributes for your model
    # attr_accessible :email, :password, :password_confirmation, :remember_me

    #attr_accessible :name, :profile_attributes,:role_attributes,:group_attributes,:user_status,:invite_code,:confirming,:invite_attributes

    accepts_nested_attributes_for :profile,   :allow_destroy => true
    accepts_nested_attributes_for :roles,:groups
  
    
    
    validates :email,     :presence => true,
                          :uniqueness => { :case_sensitive => true },
                          :format => { :with => Devise.email_regexp }
    
    #validates_format_of :email, :with => Devise.email_regexp, :allow_blank => false, :if => :email_changed?                      
    validates :password,  :presence => {:on => :create},
                          :confirmation => true,
                          :length => { :within => Devise.password_length,:on => :create },
                          #:if => lambda { |user| user.user_status > 0 || (user.user_status == 0 && user.confirming)}
                          :if => lambda { |user| user.user_status == 0} #only check for password on account creation where user status = 0
  
    validates :password,  :presence => {:on => :update},
                          :confirmation => true,
                          :length => { :within => Devise.password_length,:on => :update },
                          :if => lambda { |user| !user.password.nil? || (user.user_status == -1 && user.confirming)}
                          #only check password on update if password is filled in or user status = -1 and user is confirming
  
    validates :invite_code, :invite_code  => { :association => 'invite', :allow_nil => false },
                            :if => lambda { |user| user.user_status == 0 && user.confirming}
  
    delegate :name, :to => :profile
    delegate :address, :to => :profile
  
    before_save :confirm_user
    before_create :generate_invite
    after_create :send_confirmation_email
    def is_confirmed?
      self.user_status == 1
    end
  
    def account_owner?
      self.account.owner.id ==  self.id
    end
  
    def generate_invite_code
      secure_hash("#{Time.now.utc}--#{self.name}")[0..15]
    end
  
    def has_admin_privileges?
      role?(:account_admin) || role?(:god)
    end
    
    def role_symbols
      role_symbols ||= (roles || []).map {|r| r.name.underscore.to_sym}
    end
  
    def role?(role)
      role_symbols.include? role
    end
  
    def group?(group)
      groups.include? group
    end
  
    def group_members_ids
      logger.debug "members: #{groups_members.inspect}"
      groups_members.map! { |gm| gm.id }
    end
  
    def groups_members
      members = []
      groups.each  { |g| members = members | g.users}
      members
    end
  
    def as_json(options={})
        {
         :id       => self.id,
         :name         => self.name,
         :email  => self.email
        }
    end

    private 
  
      def generate_invite
        self.build_invite(:invite_code =>"#{self.generate_invite_code}",:invitee_id => self.moa.owner.id,:invite_date => Time.now) unless self.moa.nil?
      end
  
      def send_confirmation_email
        logger.debug "enquing confirmation email #{self.user_status}"
        Resque.enqueue(Emailer, self.class.name,self.id,'complete_signup') if (self.user_status <0)
      end
    
      def confirm_user
        if !self.invite_code.nil? && self.user_status == -1 && !self.invite.nil?
          self.user_status = 1
          self.invite.activated_date = Time.now
          self.invite.activated = true
        end

      end
    
      def secure_hash(string)
        Digest::SHA2.hexdigest(string)
      end
end