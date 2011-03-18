require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'pp'
require 'init'

configure do
  Student.first_or_create(:name_first => 'Eric', :name_last => 'Stokes', :email => 'stokesej@rose-hulman.edu', :pwhash => Digest::SHA1.hexdigest('password'))
end

pp "Application Starting..."

