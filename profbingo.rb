require 'bundler/setup'
require 'sinatra/base'
require 'pp'
require 'dm-core'
require 'dm-migrations'
require 'models'
require 'routes'
require 'haml'

class ProfBingo < Sinatra::Base
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
  configure do
    Student.first_or_create(:name_first => 'Eric', :name_last => 'Stokes', :email => 'stokesej@rose-hulman.edu', :pwhash => Digest::SHA1.hexdigest('password'))
    enable :static, :session
    set :root, File.dirname(__FILE__)

    set :haml, { :format => :html5 }
  end

  # Make sure DB is up to date.
  DataMapper.finalize
  DataMapper.auto_upgrade!

  #require 'routes'
  get '/' do
    haml :index
  end

  pp "Application Starting..."

  before do
    pp "A route was called"
  end
end
