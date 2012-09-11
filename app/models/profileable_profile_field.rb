class ProfileableProfileField < ActiveRecord::Base
  scope :users, :conditions => { :profileable_type => 'User' }
  
  validates :profileable_type, :inclusion => { :in => ["User"] }
  
  after_destroy :update_active_fields
  
  attr_accessible :publik,:required,:profileable_type,:profile_field_id
  
  def self.missing_profile_fields profileable_type
    profile_fields = ProfileableProfileField.find(:all, :conditions => ['profileable_type = ?',profileable_type])
    profile_fields_ids =  profile_fields.map { |pf| pf.profile_field_id }
    logger.debug "profile fields ids #{profile_fields_ids.inspect }"
    missing_fields = Array.new
    ProfileField.all.each do | pf | 
      logger.debug "profile field id #{pf.id }"
      missing_fields << pf if !profile_fields_ids.include? pf.id
    end
    missing_fields
  end
  
  private 
  
    def update_active_fields
     af_could_be_affected = ActiveField.find(:all, :conditions => ['profile_field_id = ?',profile_field_id])
     af_could_be_affected.each  do | af |
      profile = Profile.find(af.profile_id)
      af.destroy if profile.profileable_type == profileable_type
     end
   
    end
    
end