class Tweet < ActiveRecord::Base
  named_scope :popular, :order => ["local_retweet_count DESC"]
end
