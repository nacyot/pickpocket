# -*- coding: utf-8 -*-
module Pickpocket
  module Twitter
    class Tweets
      CONFIG_DIR = File.join(__dir__, "..", "..", "config")
      TMP_DIR = File.join(__dir__, "..", "..","tmp")
      
      def initialize(tweets, type = "timeline")
        @tweets = tweets
        @type = type
        #TODO
        @time_criteria = LastTweetParsed.read_last_tweet_created_at("nacyot", "timeline") || first_tweet_created_at
        extract_links
        get_titles
      end
      
      def tweets
        @tweets
      end
      
      def to_pocket
        items = []
        
        @tweets.each_with_index do |tweet, index|
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

        items
      end

      def last_tweet_created_at
        Time.parse @tweets[0].attrs[:created_at] unless @tweets.empty?
      end

      def first_tweet_created_at
        Time.parse @tweets[-1].attrs[:created_at] unless @tweets.empty?
      end

      private     
      def extract_links
        @tweets.delete_if do |tweet|
          tweet.attrs[:entities][:urls].size < 1 or Time.parse(tweet.attrs[:created_at]) <= @time_criteria
        end
      end

      def get_titles
        @tweets.each_with_index do |tweet, index|
          tweet.attrs[:entities][:urls].each do |url|
            get_title url, tweet[:text]
          end
        end

        sleep(3)
      end

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
