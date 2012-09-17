# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120914104032) do

  create_table "accounts", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "plan_id"
    t.datetime "trial_ends_at"
    t.integer  "account_status", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "active_fields", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "profile_field_id"
    t.text     "value"
    t.boolean  "publik",           :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "active_fields", ["profile_field_id"], :name => "index_active_fields_on_profile_field_id"
  add_index "active_fields", ["profile_id"], :name => "index_active_fields_on_profile_id"

  create_table "assets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "type"
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.integer  "asset_remote_url"
    t.datetime "attachment_updated_at"
  end

  create_table "assigned_groups", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "assigned_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "owner"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "invites", :force => true do |t|
    t.integer  "inviteable_id"
    t.string   "inviteable_type"
    t.integer  "invitee_id"
    t.string   "invite_code"
    t.boolean  "activated",       :default => false
    t.datetime "invite_date"
    t.datetime "activated_date"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "max_users"
    t.integer  "max_groups"
    t.integer  "max_events"
    t.integer  "max_active_events"
    t.integer  "max_event_days"
    t.integer  "price"
    t.boolean  "private"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "profile_fields", :force => true do |t|
    t.string   "name"
    t.string   "var_type"
    t.string   "input_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profileable_profile_fields", :force => true do |t|
    t.integer  "profile_field_id"
    t.string   "profileable_type"
    t.boolean  "publik"
    t.boolean  "required",         :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.integer  "address_id"
    t.integer  "profileable_id"
    t.string   "profileable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "user_status",            :default => -1
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
