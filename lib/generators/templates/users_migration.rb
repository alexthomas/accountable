class AccountableCreateUsersTables < ActiveRecord::Migration
  def change
 
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    
    create_table :assigned_roles do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
    
    create_table :groups do |t|
      t.string  :name
      t.text    :description
      t.string  :owner

      t.timestamps
    end
    
    create_table :assigned_groups do | t |
     t.references :user
     t.references :group
    end
    
    create_table :profiles do |t|
      t.string  :name
      t.integer :address_id
      t.integer :profileable_id
      t.string  :profileable_type
      t.timestamps
    end
    
    create_table :active_fields do |t|
      t.references   :profile
      t.references   :profile_field
      t.text         :value
      t.boolean      :publik, :default => false
      t.timestamps
    end
    add_index :active_fields, :profile_id
    add_index :active_fields, :profile_field_id
    
    create_table :profile_fields do |t|
      t.string :name
      t.string :var_type
      t.string :input_type
      t.timestamps
    end
    
    create_table :profileable_profile_fields do |t|
      t.references :profile_field
      t.string :profileable_type
      t.boolean :publik
      t.boolean :required, :default =>false
      t.timestamps
    end
    
    create_table :assets do |t|
      t.string   :title
      t.text     :description
      t.string   :type
      t.integer  :assetable_id
      t.string   :assetable_type
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.string   :asset_remote_url
      t.text     :metadata
      t.datetime :attachment_updated_at
      t.timestamps
    end
    
  end
end
