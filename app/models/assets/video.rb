class Video < Asset
  has_attached_file :attachment,
    :url => :attached_asset_url,
    :path => :attached_asset_path
  
  before_validation :download_remote_video, :if => :asset_url?

  validates_presence_of :asset_remote_url, :if => :asset_url?, :message => 'video url is invalid or inaccessible'

                                                      
end
