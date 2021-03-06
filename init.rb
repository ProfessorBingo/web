require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'digest/sha1'
require 'haml'
require 'json'

configure :production do
  enable :sessions
  pp "Loading Production Environment..."
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://' + Dir.pwd + '/profbingo.db') 
end

configure :test do
  enable :sessions
  pp "Loading Test Environment..."
  DataMapper.setup(:default, 'sqlite3://' + Dir.pwd + '/profbingo_test.db') 
end

configure :development do
  enable :sessions
  pp "Loading Development Environment..."
  DataMapper.setup(:default, 'sqlite3://' + Dir.pwd + '/profbingo.db') 
end
# Include the models after the database has been initialized
require 'models'
# Make sure DB is up to date.
DataMapper.finalize
DataMapper.auto_upgrade!

require 'routes'
