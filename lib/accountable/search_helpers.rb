module Accountable
  module SearchHelpers
  
    def self.extended(base)

      base.send :include, InstanceMethods
    end
  
    def class_name
      to_s
    end
  
    def search_to_active_relation(hits)
      if !hits.empty?
        sids = hits.map { | hit | hit.primary_key }
        self.where('id IN (?)', sids)
      else
        {}
      end
    end
  
    def index_all
     Self.all.each do | object |
       Resque.enqueue(SearchIndexer, self.class.name,self.id)
     end
   
    end
  
  
    module InstanceMethods
    
    
    
      def initialize(*options)
        super
      
      end
      
      def make_dirty
        dirty = (self.changed? && !self.index_status_changed?)
        self.index_status = 1 if dirty
      end
      
      def is_dirty?
        self.index_status
      end
      
      def index_search_object
        Rails.logger.debug "our current index status is ........ #{self.index_status}"
        Rails.logger.debug "is object dirty? ........ #{is_dirty?}"
        #if we have a clean index status just returned from resque worker don't set index status to dirty
        #index_status = self.index_status == 0 && !self.index_status_changed? ? 1 : 0 
        Rails.logger.debug "our updated index status is ........ #{is_dirty?}"
        Resque.enqueue(SearchIndexer,self.class.name,self.id) if is_dirty?
      end
    
    end
  
  
  end
end