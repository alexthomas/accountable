module Accountable
  module Users
    module ProfileHelpers
  
      def self.extended(base)

        base.send :include, InstanceMethods
      end
  
      def class_name
        to_s
      end
  
      #def search(search)
        #!search.nil? ? search = search.strip : search = ''
        #if search != ''
          #self.includes(:profile).where('profiles.name LIKE ?', "%#{search}%")
      
        #else
          #{}
        #end
      #end

      def order_by(order_by='name')
        self.includes(:profile).order('profiles.name')
      end

      def profile_fields
        pp_fields ||= ProfileableProfileField.where(profileable_type: class_name)
        pp_fields
      end

      def profile_field_names
        spf_ids = profile_fields.map { |spf| spf.profile_field_id }
        profile_fields = ProfileField.find(spf_ids)
        field_names = Hash.new
        profile_fields.each do |pf|
          field_names.store(pf.id,pf.name)
        end
        field_names
      end
  
      module InstanceMethods
    
        def initialize(options = {})
          super
          logger.debug "the options in init profile are #{options.inspect}"
          if options.empty?
            self.build_profile unless self.profile
            self.build_profile_fields
            logger.debug "initialising profile object #{self.profile.inspect}"
          end
          self.profile.build_photo if self.profile.photo.nil? && !options.has_key?(:photo_attributes)
        end
      
        def build_profile_fields
          spf = self.class.profile_fields
          Rails.logger.debug "in profile related #{spf.inspect}"
          af_ids = self.profile.active_fields.map { |af| af.profile_field_id}
          spf.each  do | pf |  self.profile.active_fields.build([{profile_field_id: pf.profile_field_id,publik: pf.publik }]) unless af_ids.include? pf.profile_field_id end 
        end
    
        def profile_field(field_name)
          spf = self.profile.profile_fields
          pf_id = false
          spf.each  do | pf | pf_id = pf.id if pf.name == field_name  end 
          profile_field = pf_id ? ActiveField.find(:first,:conditions =>{:profile_id => self.profile.id,:profile_field_id => pf_id}) : ''
        end
    
      end

    end
  end
end