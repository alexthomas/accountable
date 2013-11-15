require 'rails/generators/active_record'
require 'generators/accountable/orm_helpers'

module ActiveRecord
  module Generators
    class AccountableGenerator < ActiveRecord::Generators::Base
      include Accountable::Generators::OrmHelpers
      
      source_root File.expand_path("../templates", __FILE__)
      
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
            
      def create_migration_file
        
        migration_template('accounts_migration.rb', 'db/migrate/accountable_create_accounts_tables.rb') if !migration_exists?('accountable_create_accounts_tables')
        sleep(1)
        if !migration_exists?("accountable_create_devise_#{table_name}_table")
          migration_template('devise_migration.rb', "db/migrate/accountable_create_devise_#{table_name}_table.rb") 
          sleep(1)
        end
        if !migration_exists?("accountable_create_#{table_name}_tables")
          migration_template('users_migration.rb', "db/migrate/accountable_create_#{table_name}_tables.rb") 
          sleep(1)
        end
        if !migration_exists?("accountable_add_account_columns_to_#{table_name}_table")
          migration_template('add_account_columns_to_user.rb', "db/migrate/accountable_add_account_columns_to_#{table_name}_table.rb")
        end

      end
      
      # def generate_model
      #         invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      #         say("accountable root: #{Accountable::Engine.root} migration path: #{migration_path} behavior: #{behavior}")
      #       end
      #       
      #       def inject_model_content
      #         content = model_contents
      #         say("class name: #{class_name} namespaced?: #{namespaced?}")
      #         inject_into_class(model_path, class_name, content) if model_exists?
      #       end
        
    end
  end
end