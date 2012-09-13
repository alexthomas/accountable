class SearchIndexer
  @queue = :search_index_queue
  
  def self.perform(type,object_id)
    begin
      object = type.capitalize.constantize.find object_id
    rescue
      Rails.logger.debug "logging search indexer worker failed to find object..."
      return
    end
    Rails.logger.debug "logging search indexer worker create index object... #{object.inspect}"
    Sunspot.index( object )
    Sunspot.commit
    object.index_count ||= 0
    index_count = object.index_count + 1
    object.update_attribute(:index_count,index_count)
    
  end
  
end
