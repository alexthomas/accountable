class Asset < ActiveRecord::Base
    belongs_to :assetable, :polymorphic => true
    delegate :url, :to => :attachment

    # attr_accessible  :title, :description, :attachment, :attachment_file_name, :attachment_content_type, :attachment_file_size,:asset_url,:asset_remote_url,:metadata
    attr_accessor   :asset_url

    validates :title, 
                              :length => { :maximum => 255 }

    validates :description,  
                              :length => { :maximum => 1000 }

    before_validation :download_remote_asset, :if => :asset_url?

    validates_presence_of :asset_remote_url, :if => :asset_url?, :message => 'asset url is invalid or inaccessible'                      
    
    def generate_local_asset(path)
      self.attachment = do_generate_local_asset(path)
    end                   

    protected
      
      def attached_asset_url
        "/assets/:toi/:toa/:id/:style/:basename.:extension"
        # "/assets/:id/:style/:basename.:extension"
      end
         
      def attached_asset_path
        ":rails_root/public/assets/:toi/:toa/:id/:style/:basename.:extension"
        # ":rails_root/public/assets/:id/:style/:basename.:extension"
      end
     
      def asset_url?
        !self.asset_url.blank?
      end
  
      def download_remote_asset
        self.attachment = do_download_remote_asset
        self.asset_remote_url = asset_url
      end
      
      def do_generate_local_asset(path)
        Rails.logger.debug "generating local asset from path : #{path}"
        io = open(path)
        def io.original_filename; path.split('/').last; end
        io.original_filename.blank? ? nil : io
      end
      
      def do_download_remote_asset
        io = open(URI.parse(asset_url))
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      #rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
      end
  
      Paperclip.interpolates :toi  do |attachment, style|
        return "#{attachment.instance.assetable.class.name.downcase}s"
      end
  
      Paperclip.interpolates :toa  do |attachment, style|
        #type of asset - split on :: to get child asset types
        return "#{attachment.instance.class.name.split("::").last.downcase.pluralize}"
      end

end


