require 'bundler/setup'
require 'sinatra/base'
require 'pp'
require 'dm-core'
require 'dm-migrations'
require 'models'
require 'routes'
require 'helpers'
require 'haml'
require 'sass'
require 'json'
require 'cgi'

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
    # Make my life easier when testing and creates all 5 types of users
    if(Student.first(:email => 'superadmin').nil?)
      s = Student.new
      s.email = 'superadmin'
      s.last_name = 'Stokes'
      s.first_name = 'Eric'
      s.password = 'password'
      s.superadmin!
      s.valid = true
      s.save
      pp s.valid
    end
    if(Student.first(:email => 'admin').nil?)
      s = Student.new
      s.email = 'admin'
      s.last_name = 'Stokes'
      s.first_name = 'Eric'
      s.password = 'password'
      s.admin!
      s.valid = true
      s.save
    end
    if(Student.first(:email => 'supermod').nil?)
      s = Student.new
      s.email = 'supermod'
      s.last_name = 'Stokes'
      s.first_name = 'Eric'
      s.password = 'password'
      s.supermod!
      s.valid = true
      s.save
    end
    if(Student.first(:email => 'mod').nil?)
      s = Student.new
      s.email = 'mod'
      s.last_name = 'Stokes'
      s.first_name = 'Eric'
      s.password = 'password'
      s.mod!
      s.valid = true
      s.save
    end
    if(Student.first(:email => 'user').nil?)
      s = Student.new
      s.email = 'user'
      s.last_name = 'Stokes'
      s.first_name = 'Eric'
      s.password = 'password'
      s.valid = true
      s.save
    end
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
