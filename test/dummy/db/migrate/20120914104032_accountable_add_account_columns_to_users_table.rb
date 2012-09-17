class AccountableAddAccountColumnsToUsersTable < ActiveRecord::Migration
  
  def up
    add_column :users, :user_status, :integer, :default => -1
  end
  
  def down
    remove_column :users, :user_status
  end
  
end
