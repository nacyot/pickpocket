require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'twitter'
require 'pocket'
Bundler.require(:default)

# Dotenv Setting
Dotenv.load

# Load Library File
Dir[File.join(__dir__, "../lib/*.rb")].each {|file| require file }



