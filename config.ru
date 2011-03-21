require 'rubygems'
# require 'sinatra'
# require './profbingo'
# 
# ## There is no need to set directories here anymore;
# ## Just run the application
# 
# #run Sinatra::Application
# run ProfBingoAppsina
#####
# require 'rubygems'
# require File.join(File.dirname(__FILE__), 'profbingo.rb')
# 
# run ProfBingoApp
#####


require File.dirname(__FILE__) + "/profbingo.rb"


map "/" do
  run ProfBingo
end