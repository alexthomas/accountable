require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Accountable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true
      
      #include Rails::Generators::ActiveRecord
      source_root File.expand_path("../../templates", __FILE__)
      
      desc "Creates an Accountable initializer and account / user table migrations."
      
      def determin_user_model_name
        options.routes? ? say("we have routes") : say("we have no routes")
        model_name = ask("What would you like the user model to be called? [user]")
        @model_name = model_name.blank? ? "user" : model_name.downcase
        
      end
  
      
      def copy_initializer
         template "accountable_config.rb", "config/initializers/accountable.rb"
      end
      
      def generate_accountable
        invoke "accountable", [@model_name,options]
      end
      # def self.next_migration_number(dirname)
      #         if ActiveRecord::Base.timestamped_migrations
      #           Time.new.utc.strftime("%Y%m%d%H%M%S")
      #         else
      #           "%.3d" % (current_migration_number(dirname) + 1)
      #         end
      #       end
      # 
      #      def create_migration_file
      #            migration_template 'accounts_migration.rb', 'db/migrate/accountable_create_accounts_tables.rb'
      #            sleep(1)
      #            migration_template 'devise_migration.rb', 'db/migrate/accountable_create_devise_user_table.rb'
      #            sleep(1)
      #            migration_template 'users_migration.rb', 'db/migrate/accountable_create_users_tables.rb'
      #            sleep(1)
      #            migration_template 'add_account_columns_to_user.rb', 'db/migrate/accountable_add_account_columns_to_users_table.rb'
      #            
      # 
      # 
      #      end
      #      
      #      def generate_model
      #        #invoke "active_record:model", ["Video"], :migration => false unless model_exists? && behavior == :invoke
      #      end
    end
  end
end