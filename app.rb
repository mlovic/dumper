$:.unshift File.dirname(__FILE__)

require 'sinatra'
require 'tilt/erubis'
require "sinatra/activerecord"

require 'lib/thought'
require 'lib/tag'

set :database, {adapter: "sqlite3", database: "dumper.sqlite3"}
ActiveRecord::Base.logger = Logger.new('db/debug.log')

get '/' do
  @thoughts = Thought.all.reverse
  @tags = Tag.all
  erb :index
  #ActiveRecord::Base.clear_active_connections!
end

after do
  ActiveRecord::Base.clear_active_connections!
end   
