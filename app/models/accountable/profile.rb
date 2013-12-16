module Accountable
  class Profile < ActiveRecord::Base
  
      belongs_to :profileable, :polymorphic => true
  
      has_one :photo, :as => :assetable,  :class_name => "Accountable::Assets::Image", :dependent => :destroy
      # has_one :address, :as => :addressable
  
      has_many :active_fields, :dependent => :destroy
      has_many :profile_fields, :through => :active_fields
  
      accepts_nested_attributes_for :photo,   :allow_destroy => true, :reject_if => :all_blank
      accepts_nested_attributes_for :active_fields,   :allow_destroy => true, :reject_if => :all_blank
      # accepts_nested_attributes_for :address,     :allow_destroy => true
  
      validates :name,               :presence => true,
                                     :length => { :maximum => 255 }
      
      validates :dob,                :presence => true, 
                                     :date => {on_or_before: 74.years.ago, on_or_after: 24.years.ago}
                            
                                     
      attr_accessor :dob_day,:dob_month,:dob_year
      before_validation :create_dob
      
      def create_dob
        
        begin
          @dob = Date.new("#{self.dob_day}-#{self.dob_month}-#{self.dob_year}")
        rescue
          @dob = nil
        end
      end
    
    
      def public_fields
        public_fields = Hash.new
        self.active_fields.each { |af|  public_fields[af.profile_field.name] = af.value  unless !af.publik}
        public_fields
      end
  
      def json_public_fields
        public_fields = Hash.new
        self.active_fields.each { |af|  public_fields[af.profile_field.name.gsub(' ','_')] = af.value  unless !af.publik}
        public_fields
      end
      def as_json(options={})
          {
           :photo       => self.photo,
           :name  => self.name,
           :details => self.json_public_fields
          }
      end
  end
end
