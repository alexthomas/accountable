require 'cancan'
# require 'resque'
require 'will_paginate'
require 'open-uri'
require 'open_uri_redirections'
require 'paperclip'
require "mp3info"
require "devise"

require "accountable/engine"

module Accountable
  
  mattr_accessor :app_root
  
  # The parent controller all Accountable controllers inherit from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"
  
  def self.setup
    yield self
  end
  
  require "validators/invite_code_validator"
  require "validators/date_validator"
  require "accountable/models"
  require "accountable/models/creatable"
  require "accountable/search_helpers"
  require "accountable/users/accessible_helpers"
  require "accountable/users/profile_helpers"
  
  
  ActiveRecord::Base.extend Accountable::Models
  ActiveRecord::Base.send :include, Accountable::Models.const_get("InstanceMethods")
end
