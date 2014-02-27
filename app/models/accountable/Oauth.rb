module Accountable
  class Oauth < ActiveRecord::Base
      belongs_to :user
  end
end