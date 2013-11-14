class AccountableAddAccountColumnsTo<%= table_name.camelize%>Table < ActiveRecord::Migration
  
  def up
    add_column :<%= table_name%>, :user_status, :integer, :default => -1
    add_column :<%= table_name%>, :account_id, :integer
  end
  
  def down
    remove_column :<%= table_name%>, :user_status
    remove_column :<%= table_name%>, :account_id
  end
  
end
