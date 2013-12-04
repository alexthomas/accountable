class Pdf < Accountable::Asset
    
    has_attached_file :attachment,
      
      :url => :attached_asset_url,
      :path => :attached_asset_path
    
    validates_attachment_content_type :attachment, :content_type => ['application/pdf']
      
    before_validation :download_remote_asset, :if => :asset_url?

    validates_presence_of :asset_remote_url, :if => :asset_url?, :message => 'pdf url is invalid or inaccessible'
    
end
