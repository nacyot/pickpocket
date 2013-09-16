require File.join(__dir__, '..', 'config', 'boot.rb')
require "pp"

def test
t = Pickpocket::Twitter.new
t.favorites("nacyo_t").each_with_index do |favorites, index|
  f = favorites.attrs

  if f[:entities][:urls].size > 0
    puts " ============= " + index.to_s
    # puts f[:text]
    puts "name: "
    puts f[:user][:name]
    # puts f[:user][:screen_name]
    # puts f[:created_at]
    # puts f[:user][:profile_image_url]
    
    f[:entities][:urls].each do |url|
      puts "url: "
      puts url[:expanded_url]
    end
  end
  end
rescue # Twitter::Error::TooManyRequests
  puts "too many requeost"
end


def test2
  t = Pickpocket::Twitter.new
  t.timeline("nacyo_t").each do |twe|
    pp twe
  end
end


test2

