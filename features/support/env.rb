# Generated by cucumber-sinatra. (Mon Mar 21 12:56:50 -0400 2011)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'profbingo.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = ProfBingo

class ProfBingoWorld
  include Capybara
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  ProfBingoWorld.new
end
