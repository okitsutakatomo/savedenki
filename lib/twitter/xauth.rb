module Twitter
  class Xauth
    attr_reader :ctoken, :csecret, :access_token, :consumer_options

    # Options
    #   :sign_in => true to just sign in with twitter instead of doing oauth authorization
    #               (http://apiwiki.twitter.com/Sign-in-with-Twitter)
    def initialize(ctoken, csecret, options={})
      @ctoken, @csecret, @consumer_options = ctoken, csecret, {}

      #  if options[:sign_in]
      #    @consumer_options[:authorize_path] =  '/oauth/authenticate'
      #  end
    end

    def consumer
      @consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => 'https://api.twitter.com'}.merge(consumer_options))
    end

    def retrieve_access_token(username, password)
      @access_token ||= consumer.get_access_token(nil, {}, {
        :x_auth_mode => "client_auth",
        :x_auth_username => username,
        :x_auth_password => password,
      })
      @atoken, @asecret = @access_token.token, @access_token.secret
    end

  end
end
