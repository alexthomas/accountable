require 'cancan'
require 'jquery-rails'

require "accountable/engine"

module Accountable
  
  mattr_accessor :app_root
  
  def self.setup
    yield self
  end
  
  require "validators/invite_code_validator"
  require "accountable/models"
  require "accountable/search_helpers"
  require "accountable/users/accessible_helpers"
  require "accountable/users/profile_helpers"
  
  
  ActiveRecord::Base.extend Accountable::Models
  ActiveRecord::Base.send :include, Accountable::Models.const_get("InstanceMethods")
end
