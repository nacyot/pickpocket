module Pickpocket
  class PickTwitter
    def self.pick(id)
      #tweets = Twitter::Tweets.new(TwitterClient.instance.fetch_timeline(id)).to_pocket
      tweets = Twitter::Tweets.new(Twitter::TweetsBackup.restore)
      PocketClient.instance.modify tweets.to_pocket
      #TODO
      Twitter::LastTweetParsed.write_last_tweet_created_at(tweets.last_tweet_created_at, "nacyot", "timeline")
    rescue= > e
      puts e
    end
  end
end
