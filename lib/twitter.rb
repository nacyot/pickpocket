require File.join(__dir__, '..', 'config', 'boot.rb')

module Pickpocket
  CONFIG_DIR = File.join(__dir__, "..", "config")
  TMP_DIR = File.join(__dir__, "..", "tmp")
  
  class Twitter
    attr_reader :timeline, :tweets_has_link

    def initialize(id)
      @timeline = nil
      @tweets_has_link = nil
      @id = id
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

    def timeline
      @timeline = @timeline || fetch_timeline
    end

    def tweets_has_link
      @tweets_has_link = @tweets_has_link || extract_links
    end
    
    def fetch_timeline
      @twitter.user_timeline @id, fetch_options
    end

    def extract_links
      @tweets_has_link = timeline.delete_if do |tweet|
        tweet.attrs[:entities][:urls].size < 1
      end
    end
    
    def fetch_favorites
    end
    
    def tmp_timeline_file
      File.join(TMP_DIR, "timeline.dump")
    end
    
    def save_tmp_timeline
      File.open(tmp_timeline_file, "w+") do |f|
        f.write Marshal.dump(timeline[0..20])
      end
    end

    def restore_tmp_timeline
      timeline = Marshal.restore File.read(tmp_timeline_file)
    end

    def get_titles
      tweets_has_link.each_with_index do |tweet, index|
        tweet.attrs[:entities][:urls].each do |url|
          # puts "#{url[:expanded_url]}, #{index}"
          get_title url, tweet[:text]
        end
      end

      sleep(3)
    end

    def get_title(url, text = "")
      Thread.new do
        begin
          timeout(3) do
            charset = ""
            html = open(url[:expanded_url], "r") do |f|
              charset = f.charset
              f.read

            end
            url[:title] = ::Nokogiri::HTML.parse(html, nil, "UTF-8").at('head/title').content
            puts "#{url[:title]} #{url[:title].encoding} #{url[:expanded_url]}"
            
          end
        rescue TimeoutError => e
          url[:title] = text
        rescue => e
          url[:title] = text
        end
      end
    end
    
    def has_all_urls_title?(tweets)
      tweets.each do |tweet|
        tweet.attrs[:entities][:urls].each do |url|
          return false unless url.has_key? :title
        end
      end

      return true
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
      last_tweet_from_file.zero? ? timeline[0].attrs[:id] : file
    end

    def last_tweet_from_file
      File.read(last_tweet_file).to_i
    end
    
    def save_last_tweet_id
      File.open last_tweet_file, "w+" do |f|
        f.write timeline[0].attrs[:id]
      end
    end
  end
end
