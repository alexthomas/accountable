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
    
      def index_search_object
        Resque.enqueue(SearchIndexer,self.class.name,self.id) if !self.index_count_changed?
      end
    
    end
  
  
  end
end