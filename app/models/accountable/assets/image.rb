module Accountable
  module Assets
    class Image < Accountable::Asset

      # attr_accessible :attachment

      has_attached_file   :attachment,
          :styles => {
            :thumb=> "100x100#",
            :small  => "150x150>" 
          },
          :url => :attached_asset_url,
          :path => :attached_asset_path
    
      #validates_attachment_presence :image
      validates_attachment_size :attachment, :less_than => 4.megabytes
      validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png','image/gif']

      def as_json(options={})
          {
           :remote_url       => self.image_remote_url,
           :local_url  => self.url,
           :small_url  => self.url(:small),
           :thumb_url  => self.url(:thumb)
          }
      end


    end
  end
end

