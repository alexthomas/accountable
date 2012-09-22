class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  delegate :url, :to => :attachment

  attr_accessible  :title, :description, :attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size,:asset_url
  attr_accessor   :asset_url

  validates :title, 
                            :length => { :maximum => 255 }

  validates :description,  
                            :length => { :maximum => 1000 }

  before_validation :download_remote_asset, :if => :asset_url?

  validates_presence_of :image_remote_asset, :if => :asset_url?, :message => 'asset url is invalid or inaccessible'                      
                          


  protected
  
    def attached_asset_url
      "/assets/:toa/:toi/:attachment/:id/:style/:basename.:extension"
    end

    def attached_asset_path
      ":rails_root/public/assets/:toa/:toi/:attachment/:id/:style/:basename.:extension"
    end
  
    def asset_url?
      !self.asset_url.blank?
    end
  
    def download_remote_asset
      self.image = do_download_remote_image
      self.image_remote_url = image_url
    end

    def do_download_remote_asset
      io = open(URI.parse(image_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    end
  
    Paperclip.interpolates :toi  do |attachment, style|
    
      if defined? attachment.instance.assetable.profileable_type
        return attachment.instance.assetable.profileable_type.downcase
      else
        return 'site'
      end
    end
  
    Paperclip.interpolates :toa  do |attachment, style|
      return attachment.instance.class.name.downcase
    end

end
