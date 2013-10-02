module Pickpocket
  module Twitter
    class LastTweetParsed
      PICKPOCKET_DIR = File.join(ENV['HOME'], ".pickpocket")

      def self.tweet_file(id, type)
        File.join(PICKPOCKET_DIR, type, id)
      end
      
      def self.read_last_tweet_created_at(id, type)
        Marshal.restore File.read(tweet_file(id, type)) if File.exists? tweet_file(id, type)
      end

      def self.write_last_tweet_created_at(date, id, type)
        dir = tweet_file(id, type)
        Dir.mkdir PICKPOCKET_DIR unless Dir.exists? PICKPOCKET_DIR
        Dir.mkdir File.dirname(dir) unless Dir.exists? File.dirname(dir)
        File.open(dir, "w+") do |f|
          f.write Marshal.dump(date)
        end
      end
    end
  end
end

