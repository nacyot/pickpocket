require File.join(__dir__, '..', 'config', 'boot.rb')

puts ENV["TWITTER_CONSUMER_KEY"]

Twitter.configure do |config|
  config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
  config.oauth_token = ENV["TWITTER_OAUTH_TOKEN"]
  config.oauth_token_secret = ENV["TWITTER_OAUTH_SECRET"]
end

#Twitter.home_timeline.each do |tweet|
#  pp tweet
#end

Twitter.followers('nacyo_t', options = { :cursor => -1 }).each do |fol|
  puts fol.name
end

