class Audio < Accountable::Asset
    
    has_attached_file :attachment,
      :url => :attached_asset_url,
      :path => :attached_asset_path
  
    before_validation :download_remote_video, :if => :asset_url?

    validates_presence_of :asset_remote_url, :if => :asset_url?, :message => 'audio url is invalid or inaccessible'

    validates_attachment_size :attachment, :less_than => 5.megabytes,
        :message => 'filesize must be less than 5 MegaBytes'
    validates_attachment_content_type :attachment, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ],
                    :message => 'file must be of filetype .mp3'
    before_save :extract_metadata
    serialize :metadata
    
    def audio?
      attachment_content_type =~ %r{^audio/(?:mp3|mpeg|mpeg3|mpg|x-mp3|x-mpeg|x-mpeg3|x-mpegaudio|x-mpg)$}
    end
    
    # MP3-aware display name, consisting of track title and artist
    # Force encoding required to deal with mixed content bugs on Ruby 1.9
    # @return 'Title - Artist' if audio file
    # @return 'file.ext' if not audio file
    def display_name
      @display_name ||= if audio? && metadata?
        artist, title = metadata.values_at('artist', 'title')
        title.present? ? [title, artist].compact.join(' - ').force_encoding('UTF-8') : attachment_file_name
      else
        attachment_file_name
      end
    end

    private

    # Retrieves metadata for MP3s
    def extract_metadata
      return unless audio?
      path = attachment.queued_for_write[:original].path
      open_opts = { :encoding => 'utf-8' }
      Mp3Info.open(path, open_opts) do |mp3info|
        self.metadata = mp3info.tag
      end
    end
end
