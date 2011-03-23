require 'bundler/setup'
require 'sinatra/base'
require 'pp'
require 'dm-core'
require 'dm-migrations'
require 'models'
require 'routes'
require 'helpers'
require 'haml'
require 'json'

class ProfBingo < Sinatra::Base
  
  configure :production do
    enable :sessions
    pp "Loading Production Environment..."
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://' + Dir.pwd + '/profbingo.db') 
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  configure :test do
    enable :sessions
    pp "Loading Test Environment..."
    DataMapper.setup(:default, 'sqlite3://' + Dir.pwd + '/profbingo_test.db') 
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  configure :development do
    enable :sessions
    pp "Loading Development Environment..."
    DataMapper.setup(:default, 'sqlite3://' + Dir.pwd + '/profbingo.db') 
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
  # Include the models after the database has been initialized

  configure do
    s = Student.first_or_new
    s.email = 'stokesej@rose-hulman.edu'
    s.last_name = 'Stokes'
    s.first_name = 'Eric'
    s.password = 'password'
    s.permissions = 'admin'
    s.save
    enable :static, :session
    set :root, File.dirname(__FILE__)

    set :haml, { :format => :html5 }
  end

  # Make sure DB is up to date.
  

  # Include our routes in a seperate file for cleanliness 
  include Routes
  
  include Helpers

  pp "Application Starting..."

  before do
    # pp "A route was called"
  end
end
