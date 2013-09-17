module Pickpocket
  class PickTwitter
    def self.pick(tweets)
      items = []
      
      tweets.each_with_index do |tweet, index|
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

      PocketClient.instance.modify(items)
    end
  end
end
