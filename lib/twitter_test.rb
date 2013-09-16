require File.join(__dir__, '..', 'config', 'boot.rb')

t = Pickpocket::Twitter.new
t.followers
