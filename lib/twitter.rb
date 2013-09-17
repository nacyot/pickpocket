require File.join(__dir__, '..', 'config', 'boot.rb')

module Pickpocket
  CONFIG_DIR = File.join(__dir__, "..", "config")
  TMP_DIR = File.join(__dir__, "..", "tmp")
  
  class Twitter
    attr_reader :timeline, :tweets_has_link

    def initialize(id)
      @id = id
      @timeline = []

      set_twitter_configuration
      set_pocket_configuration
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
    
    def set_pocket_configuration
      Pocket.configure do |config|
        config.consumer_key = ENV['POCKET_CONSUMER_KEY']
      end
      
      @pocket = Pocket.client(:access_token => ENV['POCKET_OAUTH_TOKEN'])
    end
    
    def fetch_timeline
      @timeline = @twitter.user_timeline @id, fetch_options
    end

    def tmp_timeline_file
      File.join(TMP_DIR, "timeline.dump")
    end
    
    def save_tmp_timeline
      File.open(tmp_timeline_file, "w+") do |f|
        f.write Marshal.dump(@timeline[0..20])
      end
    end

    def restore_tmp_timeline
      @timeline = Marshal.restore File.read(tmp_timeline_file)
    end
    
    def extract_links
      @tweets_has_link = @timeline.delete_if do |tweet|
        tweet.attrs[:entities][:urls].size < 1
      end

    end

    def get_titles
      @tweets_has_link.each_with_index do |tweet, index|
        tweet.attrs[:entities][:urls].each do |url|
          #"url" => url[:expanded_url]
          Thread.new do
            begin
              timeout(3) do
                puts url[:expanded_url] + " #  #{index}"
                charset = ""
                html = open(url[:expanded_url], "r") do |f|
                  charset = f.charset
                  f.read
                end

                url[:title] = ::Nokogiri::HTML.parse(html, nil, charset).at('head/title').content
                puts "success fetch #{url[:title]} # #{index}"
              end
            rescue TimeoutError => e
              url[:title] = tweet[:text]
              puts "fails fetch #{$1} because of timeout"
            rescue => e
              pp e 
              puts "fails ???"
            end
          end
        end

        
      end

      nil

    end

    def has_all_urls_title?(tweets)
      tweets.each do |tweet|
        tweet.attrs[:entities][:urls].each do |url|
          return false unless url.has_key? :title
        end
      end

      return true
    end
    
    def pickpocket_test
      @pocket.modify(
                    [
                     { "action" => "add",
                       "url" => "http://getpocket.com/developer/docs/v3/modify"
                     }
                    ]
                    )
    end
    
    def pickpocket
      items = []
      
      @tweets_has_link.each_with_index do |tweet, index|
        tweet = tweet.attrs
        tweet[:entities][:urls].each do |url|
          
          items << {
            "action" => "add",
            "title" => url[:title],
            "url" => url[:expanded_url],
            "time" => tweet[:created_at],
            "ref_id" => tweet[:id],
            "tags" => [tweet[:user][:sceen_name],
                       tweet[:user][:name],
                       "pickpocket"]
          }
        end

      end

      pp items
      @pocket.modify(items)
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
