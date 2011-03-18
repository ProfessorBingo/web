configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://' + Dir.pwd + '/profbingo.db') 
end

require 'models'