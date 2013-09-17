require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'open-uri'
require 'dotenv'
require 'twitter'
require 'pocket'
require 'nokogiri'
require 'resolv-replace'
require 'kconv'
require 'timeout'
require 'singleton'

# Dotenv Setting
Dotenv.load

# Load Library File
Dir[File.join(__dir__, "../lib/*.rb")].each {|file| require file }



