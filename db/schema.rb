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

ActiveRecord::Schema.define(:version => 20110316062753) do

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tweets", :force => true do |t|
    t.integer  "original_id",            :limit => 8,                    :null => false
    t.string   "id_str",                                                 :null => false
    t.string   "text"
    t.integer  "retweet_count",                       :default => 0
    t.string   "geo"
    t.boolean  "retweeted",                           :default => false
    t.string   "source"
    t.string   "user_name"
    t.string   "user_location"
    t.string   "user_profile_image_url"
    t.string   "user_id_str"
    t.integer  "user_id",                                                :null => false
    t.integer  "user_followers_count"
    t.integer  "user_statuses_count"
    t.integer  "user_friends_count"
    t.string   "user_screen_name"
    t.datetime "original_created_at"
    t.text     "hashtext"
    t.integer  "local_retweet_count",                 :default => 0
    t.integer  "retweeted_id",           :limit => 8
    t.string   "retweet_category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets", ["original_created_at"], :name => "index_tweets_on_original_created_at"
  add_index "tweets", ["original_id"], :name => "index_tweets_on_original_id"
  add_index "tweets", ["retweeted_id"], :name => "index_tweets_on_retweeted_id"
  add_index "tweets", ["text"], :name => "index_tweets_on_text"
  add_index "tweets", ["user_id"], :name => "index_tweets_on_user_id"

end
