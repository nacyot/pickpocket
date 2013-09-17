module Pickpocket
  module Twitter
    class Tweets
      CONFIG_DIR = File.join(__dir__, "..", "..", "config")
      TMP_DIR = File.join(__dir__, "..", "..","tmp")
      
      def initialize(tweets)
        @tweets = tweets
        extract_links
      end

      def tweets
        @tweets
      end

      def extract_links
        @tweets.delete_if do |tweet|
          tweet.attrs[:entities][:urls].size < 1
        end
      end

      def get_titles
        tweets.each_with_index do |tweet, index|
          tweet.attrs[:entities][:urls].each do |url|
            get_title url, tweet[:text]
          end
        end

        sleep(3)
      end

      private
      def get_title(url, text = "")
        Thread.new do
          begin
            timeout(3) { url[:title] = parse_title(url[:expanded_url]) }
          rescue TimeoutError => e
            url[:title] = text
          rescue => e
            url[:title] = text
          end
        end
      end

      def parse_title(url)
         ::Nokogiri::HTML.parse(open(url, "r").read.toutf8, nil, "UTF-8").at('head/title').content
      end
    end
  end
end
