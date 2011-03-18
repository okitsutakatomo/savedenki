module TwitterStreamUtil
  class Filter < TwitterStreamUtil::RestartLoop

    def initialize(retry_count, retry_seconds, wait_seconds, username, password, track)
      super(retry_count, retry_seconds, wait_seconds)
      @username = username
      @password = password
      @track = track
    end

    def execute()
      ts = TwitterStream.new({ :username => @username, :password => @password})
      ts.track(@track) do |status|

        begin
          save_tweet(status)
        rescue => e
          RAILS_DEFAULT_LOGGER.error e
        end

        # リトライなのかチェック
        if restart?()
          RAILS_DEFAULT_LOGGER.info "再起動成功" + make_error_msg()
          success_restart()
        end
      end
    end

    def save_tweet(status)

      #tweetを保存する。
      @tweet = Tweet.new

      @tweet.original_id = status["id"]
      @tweet.id_str = status["id_str"]
      @tweet.text = status["text"]
      @tweet.retweet_count = status["retweet_count"]
      @tweet.geo  = status["geo"]
      @tweet.retweeted   = status["retweeted"]
      @tweet.source   = status["source"]
      @tweet.original_created_at = status["created_at"]
      @tweet.hashtext = status.inspect

      if status["user"]
        @tweet.user_name = status["user"]["name"]
        @tweet.user_location  = status["user"]["location"]
        @tweet.user_profile_image_url  = status["user"]["profile_image_url"]
        @tweet.user_id_str = status["user"]["id_str"]
        @tweet.user_id = status["user"]["id"]
        @tweet.user_followers_count = status["user"]["followers_count"]
        @tweet.user_statuses_count = status["user"]["statuses_count"]
        @tweet.user_friends_count = status["user"]["friends_count"]
        @tweet.user_screen_name = status["user"]["screen_name"]
      end

      #保存する
      @tweet.save!

      #公式RTの場合
      if status["retweeted_status"] and status["retweeted_status"]["id"]
        retweeted_id = status["retweeted_status"]["id"]
        @parent_tweet = Tweet.find_by_original_id(retweeted_id)
        if @parent_tweet
          #親のツイートが見つかった場合は、親のツイートのローカルRTカウントをインクリメントする。
          @parent_tweet.local_retweet_count += 1
          @parent_tweet.save!

          #つぶやきステータスを追加する。
          @tweet.retweeted_id = retweeted_id
          @tweet.retweet_category = "official"

        end

        #非公式RTの場合
      elsif @tweet.text.include?("RT ")
        # 「てすと RT @okitsu: @okitsu 節電中」を、「@okitsu 節電中」に変換する正規表現
        parent_tweet_str = @tweet.text.gsub(/.*:\s/,"").strip
        if !parent_tweet_str.blank?
          @parent_tweet = Tweet.find_by_text(parent_tweet_str)
          if @parent_tweet
            #親のツイートが見つかった場合は、親のツイートのローカルRTカウントをインクリメントする。
            @parent_tweet.local_retweet_count += 1
            @parent_tweet.save!

            #つぶやきステータスを追加する。
            @tweet.retweeted_id = @parent_tweet.original_id
            @tweet.retweet_category = "unofficial"
          end
        end
      end

      @tweet.save!
    end


    # リトライ失敗時の処理
    def fail_restart()
      RAILS_DEFAULT_LOGGER.info "再起動失敗" + make_error_msg()
    end
  end
end
