require File.join(__dir__, '..', 'config', 'boot.rb')
require "pp"

def test

  f = favorites.attrs

  if f[:entities][:urls].size > 0

  end
  end
rescue # Twitter::Error::TooManyRequests
  puts "too many requeost"
end


def test2
  t = Pickpocket::Twitter.new
  t.timeline("nacyo_t").each do |twe|
    pp twe
    p
  end
end


test2
