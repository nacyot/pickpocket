require File.join(__dir__, '..', 'config', 'boot.rb')

module Pickpocket
  class TwitterClient
    include ::Singleton
    
    def fetch_timeline(id)
      @twitter.user_timeline id, fetch_options
    end

    def fetch_favorites(id)
    end

    private    
    def initialize
      set_twitter_configuration
    end

    def set_twitter_configuration
      @twitter = ::Twitter
      @twitter.configure do |config|
        config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
        config.oauth_token = ENV["TWITTER_OAUTH_TOKEN"]
        config.oauth_token_secret = ENV["TWITTER_OAUTH_SECRET"]
      end
    end    

    # def tweet_id_file
    #   File.join(CONFIG_DIR, ".first_timeline")
    # end

    # def first_tweet_from_file
    #   File.read(first_tweet_file).to_i
    # end
    
    # def last_tweet_file
    #   File.join(CONFIG_DIR, ".last_timeline")
    # end

    #def last_tweet_from_file
    #   File.read(last_tweet_file).to_i
    # end

    # def save_last_tweet_id(tweets)
    #   File.open last_tweet_file, "w+" do |f|
    #     f.write tweets[0].attrs[:id]
    #   end
    # end
    
    private
    def fetch_options
      options = {}
      #options[:since_id] = last_tweet_id unless
      #last_tweet_from_file.zero?
      options[:count] = 200

      options
    end
  end
end
