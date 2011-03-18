DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://' + Dir.pwd + '/profbingo.db') 
require 'models'

DataMapper.finalize
DataMapper.auto_upgrade!