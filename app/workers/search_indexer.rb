class SearchIndexer
  @queue = :search_index_queue
  
  def self.perform(type,object_id)
    begin
      object = type.capitalize.constantize.find object_id
    rescue
      Rails.logger.debug "logging search indexer worker failed to find object..."
      return
    end
    Rails.logger.debug "our index status is #{object.index_status}"
    Rails.logger.debug "logging search indexer worker create index object... #{object.inspect}"
    Sunspot.index( object )
    Sunspot.commit
    object.update_attribute(:index_status,0) #set index status to clean after reindex
    
  end
  
end
