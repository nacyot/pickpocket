require File.join(__dir__, '..', 'config', 'boot.rb')
require 'coveralls'
Coveralls.wear!


RSpec.configure do |c|
  c.filter_run_excluding :long_time => true
end

