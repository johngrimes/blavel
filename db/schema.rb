# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1010) do

  create_table "continents", :force => true do |t|
    t.string "code", :limit => 2
    t.string "name", :limit => 50
  end

  add_index "continents", ["code"], :name => "index_continents_on_code", :unique => true

  create_table "countries", :id => false, :force => true do |t|
    t.string  "code",               :limit => 2
    t.string  "iso_alpha_3",        :limit => 3
    t.integer "iso_numeric"
    t.string  "fips_code",          :limit => 2
    t.string  "name"
    t.string  "capital"
    t.string  "area_in_sq_km",      :limit => 20
    t.string  "population",         :limit => 20
    t.string  "continent_id",       :limit => 2
    t.string  "tld",                :limit => 3
    t.string  "currency_code",      :limit => 3
    t.string  "currency_name",      :limit => 30
    t.string  "phone",              :limit => 30
    t.string  "postal_code_format", :limit => 500
    t.string  "postal_code_regex",  :limit => 500
    t.string  "languages"
    t.integer "location_id"
    t.string  "neighbours"
    t.string  "equivalent_fips",    :limit => 20
  end

  add_index "countries", ["code"], :name => "index_countries_on_code", :unique => true

  create_table "facebook_templates", :force => true do |t|
    t.string "template_name", :null => false
    t.string "content_hash",  :null => false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

  create_table "facebook_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "facebook_id"
    t.string   "session_key"
    t.datetime "created_at"
  end

  add_index "facebook_users", ["user_id"], :name => "index_facebook_users_on_user_id"
  add_index "facebook_users", ["facebook_id"], :name => "index_facebook_users_on_facebook_id"

  create_table "follows", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at"
  end

  add_index "follows", ["follower_id"], :name => "index_follows_on_follower_id"
  add_index "follows", ["followee_id"], :name => "index_follows_on_followee_id"

  create_table "location_types", :force => true do |t|
    t.string "code",        :limit => 1
    t.string "description", :limit => 50
  end

  add_index "location_types", ["code"], :name => "index_location_types_on_code", :unique => true

  create_table "locations", :force => true do |t|
    t.string  "name",                  :limit => 200
    t.string  "ascii_name",            :limit => 200
    t.string  "alternate_names",       :limit => 5000
    t.string  "latitude",              :limit => 20
    t.string  "longitude",             :limit => 20
    t.string  "location_type_code",    :limit => 1
    t.string  "feature_class",         :limit => 10
    t.string  "country_code",          :limit => 2
    t.string  "alternate_iso_alpha_2", :limit => 60
    t.string  "admin_1_code",          :limit => 20
    t.string  "admin_2_code",          :limit => 80
    t.string  "admin_3_code",          :limit => 20
    t.string  "admin_4_code",          :limit => 20
    t.integer "population"
    t.string  "elevation",             :limit => 20
    t.string  "gtopo30",               :limit => 20
    t.string  "time_zone",             :limit => 50
    t.date    "modification_date"
  end

  create_table "locations_posts", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "location_id"
  end

  add_index "locations_posts", ["post_id"], :name => "index_locations_posts_on_post_id"
  add_index "locations_posts", ["location_id"], :name => "index_locations_posts_on_location_id"

  create_table "mailees", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.text     "content"
    t.boolean  "read",         :default => false
    t.datetime "created_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "post_id"
    t.integer  "picture_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
  end

  add_index "notes", ["post_id"], :name => "index_notes_on_post_id"
  add_index "notes", ["picture_id"], :name => "index_notes_on_picture_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "pictures", :force => true do |t|
    t.integer  "post_id"
    t.string   "title"
    t.string   "description",  :limit => 300
    t.integer  "location_id"
    t.integer  "sequence"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["parent_id", "thumbnail"], :name => "index_pictures_on_parent_id_and_thumbnail", :unique => true
  add_index "pictures", ["post_id"], :name => "index_pictures_on_post_id"
  add_index "pictures", ["location_id"], :name => "index_pictures_on_location_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "profile_pictures", :force => true do |t|
    t.integer  "user_id"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_pictures", ["parent_id", "thumbnail"], :name => "index_profile_pictures_on_parent_id_and_thumbnail", :unique => true
  add_index "profile_pictures", ["user_id"], :name => "index_profile_pictures_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "first_name"
    t.string   "surname"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "home_town"
    t.text     "about_me"
    t.text     "fave_travel_experience"
    t.string   "languages"
    t.string   "time_zone"
    t.boolean  "admin"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["activation_code"], :name => "index_users_on_activation_code", :unique => true

end
