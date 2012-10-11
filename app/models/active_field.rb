class ActiveField < ActiveRecord::Base
    belongs_to :profile
    belongs_to :profile_field
  
    attr_accessible :profile_field_id,:value,:publik
  
    def as_json(options={})
    
        {:id       => self.id,
         :value => self.value
        }
    end

end
