require 'twitter'
require 'pp'

Twitter.configure do |config|
  config.consumer_key = "I8yGExSE3xw1nPQKGJigQ"
  config.consumer_secret = "QjrIbWXseR0nV66MCchlkqYxlcAtuOLpsVatJBIGM"
  config.oauth_token = "560970641-gk8f3YRtlaCAj3WKyx5t33Btz81rXwpmtnv6gb2s"
  config.oauth_token_secret = "yBQ5vlWa6EZIQ2U7hzFnYIn5g3bNA3JzM8YaiNAIj8"
end


#Twitter.home_timeline.each do |tweet|
#  pp tweet
#end

Twitter.followers('nacyo_t', options = { :cursor => -1 }).each do |fol|
  puts fol.name
end

end
end
