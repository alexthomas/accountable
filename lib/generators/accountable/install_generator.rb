require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Accountable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      #include Rails::Generators::ActiveRecord
      
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates an Accountable initializer and account / user table migrations."

      def copy_initializer
        template "accountable_config.rb", "config/initializers/accountable.rb"
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def create_migration_file
            migration_template 'accounts_migration.rb', 'db/migrate/accountable_create_accounts_tables.rb'
            sleep(1)
            migration_template 'users_migration.rb', 'db/migrate/accountable_create_users_tables.rb'
            


      end
      
      def generate_model
        #invoke "active_record:model", ["Video"], :migration => false unless model_exists? && behavior == :invoke
      end
    end
  end
end