require File.join(__dir__, '..', 'config', 'boot.rb')

module Pickpocket
  CONFIG_DIR = File.join(__dir__, "..", "config")
  
  class Twitter
    def initialize(id)
      @twitter = ::Twitter
      @twitter.configure do |config|
        config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
        config.oauth_token = ENV["TWITTER_OAUTH_TOKEN"]
        config.oauth_token_secret = ENV["TWITTER_OAUTH_SECRET"]
      end

      @id = id
    end

    def fetch_timeline
      @timeline = @twitter.user_timeline @id, fetch_options
    end

    def extract_links
      @tweets_has_link = @timeline.delete_if do |tweet|
        tweet.attrs[:entities][:urls].size < 1
      end
    end

    def pickpocket
      @tweets_has_link.each_with_index do |tweet, index|
        tweet = tweet.attrs
        
        puts " ============= " + index.to_s
        # puts f[:text]
        puts "name: "
        puts tweet[:user][:name]
        # puts f[:user][:screen_name]
        # puts f[:created_at]
        # puts f[:user][:profile_image_url]
        
        tweet[:entities][:urls].each do |url|
          puts "url: "
          puts url[:expanded_url]
        end
      end
    end

    def fetch_options
      options = {}
      options[:since_id] = last_tweet_id unless last_tweet_from_file.zero?
      options[:count] = 200

      options
    end

    def last_tweet_file
      File.join(CONFIG_DIR, ".last_tweet")
    end
    
    def last_tweet_id
      last_tweet_from_file.zero? ? @timeline[0].attrs[:id] : file
    end

    def last_tweet_from_file
      File.read(last_tweet_file).to_i
    end
    
    def save_last_tweet_id
      File.open last_tweet_file, "w+" do |f|
        f.write @timeline[0].attrs[:id]
      end
    end
    


    
    # def set_favorites
    #   @favorites = @twitter.favorites @id
    # end
    
    # def last_tweet_at
    #   @timeline[0].attrs[:id] unless @favorites.nil?
    # end

    # def last_favorite_at
    #   @favorites[0].attrs[:id] unless @favorites.nil?
    # end
  end
end
