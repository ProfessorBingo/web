require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'haml'
require 'pp'



configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://' + Dir.pwd + '/profbingo.db') 
end

require 'models'

DataMapper.finalize
DataMapper.auto_upgrade!

# Quick test
get '/' do
  "Woot!
  ProfBingo is running on Heroku!"
end