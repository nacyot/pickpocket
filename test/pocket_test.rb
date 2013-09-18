# Copyright (c) 2012 Geknowm, Inc. Portions
# Copyright (c) 2011 Instagram (Burbn, Inc.)
# https://github.com/Geknowm/pocket-ruby/blob/master/demo-server.rb
# This code based on pocket-ruby/demo-nerver.rb

require File.join(__dir__, '..', 'config', 'boot.rb')
require 'sinatra'

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Pocket.configure do |config|
  config.consumer_key = ENV['POCKET_CONSUMER_KEY']
end

get '/reset' do
  puts "GET /reset"
  session.clear
end

get "/" do
  puts "GET /"
  puts "session: #{session}"
    
  if session[:access_token]
    '
<a href="/add?url=http://geknowm.com">Add Geknowm</a>
<a href="/retrieve">Retrieve items</a>
' + "<br /> Your Pocket access token: " + session[:access_token]
  else
    '<a href="/oauth/connect">Connect with Pocket</a>'
  end
end

get "/oauth/connect" do
  puts "OAUTH CONNECT"
  session[:code] = Pocket.get_code(:redirect_uri => CALLBACK_URL)
  new_url = Pocket.authorize_url(:code => session[:code], :redirect_uri => CALLBACK_URL)
  puts "new_url: #{new_url}"
  puts "session: #{session}"
  redirect new_url
end

get "/oauth/callback" do
  puts "OAUTH CALLBACK"
  puts "request.url: #{request.url}"
  puts "request.body: #{request.body.read}"
  access_token = Pocket.get_access_token(session[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = access_token
  puts "session: #{session}"
  redirect "/"
end

