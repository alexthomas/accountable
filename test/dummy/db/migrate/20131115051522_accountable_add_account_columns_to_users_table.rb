class AccountableAddAccountColumnsToUsersTable < ActiveRecord::Migration
  
  def up
    add_column :users, :user_status, :integer, :default => -1
    add_column :users, :account_id, :integer
  end
  
  def down
    remove_column :users, :user_status
    remove_column :users, :account_id
  end
  
end
