require 'rails/generators/active_record'
require 'generators/accountable/orm_helpers'

module ActiveRecord
  module Generators
    class AccountableGenerator < ActiveRecord::Generators::Base
      
      def install_gen
        ask "i am install"
      end
    end
  end
end