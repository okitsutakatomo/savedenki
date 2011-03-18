class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :original_id, :limit => 8, :null => false
      t.string :id_str, :null => false
      t.string :text
      t.integer :retweet_count, :default => 0
      t.string :geo
      t.boolean :retweeted, :default => false
      t.string :source
      t.string :user_name
      t.string :user_location
      t.string :user_profile_image_url
      t.string :user_id_str
      t.integer :user_id, :null => false
      t.integer :user_followers_count
      t.integer :user_statuses_count
      t.integer :user_friends_count
      t.string :user_screen_name
      t.timestamp :original_created_at
      t.text :hashtext
      t.integer :local_retweet_count, :default => 0 #実際本システムで利用するリツイート数
      t.integer :retweeted_id, :limit => 8 #元のツイートのID
      t.string :retweet_category #official, unofficial
      t.timestamps
    end

    add_index :tweets, :original_id
    add_index :tweets, :text
    add_index :tweets, :user_id
    add_index :tweets, :original_created_at
    add_index :tweets, :retweeted_id
    add_index :tweets, :created_at

  end

  def self.down
    drop_table :tweets
  end
end
