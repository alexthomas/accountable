class AccountableCreateAccountsTables < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :owner_id
      t.references :plan
      t.datetime :trial_ends_at
      t.integer :account_status, :default => 0
      t.timestamps
    end
    
    create_table :plans do |t|
      t.string  :name
      t.text    :description
      t.integer :max_users
      t.integer :max_groups
      t.integer :max_events
      t.integer :max_active_events
      t.integer :max_event_days
      t.integer :price
      t.boolean :private
      t.timestamps
    end
    
    create_table :invites do | t |
      t.references   :inviteable, :polymorphic => true
      t.integer   :invitee_id
      t.string    :invite_code
      t.boolean   :activated, :default => false
      t.datetime  :invite_date
      t.datetime  :activated_date
    end
    
  end
end
