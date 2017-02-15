require 'pp'
require 'sqlite3'
require 'mongo'
require 'active_record'
require_relative 'lib/thought'
require_relative 'lib/tag'

#sqlite = SQLite3::Database.new "test.db"
#sqlite.execute "SELECT * FROM thoughts"
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "db/dumper.sqlite3"
)

mongo = Mongo::Client.new([ '127.0.0.1:27017' ], database: 'dump')

Thought.all.each do |thought|
  h = thought.attributes.except('from_email')
  h['tags'] = thought.tags.map(&:name)
  h['num']  = thought.id
  h['body'] = (thought.title.to_s + "\n" + thought.description.to_s).strip
  h.delete('id')
  h.delete('title')
  h.delete('description')
  p h 
  mongo[:thoughts].insert_one(h)
  #mongo[:thoughts].insert_one(h)
  #exit
end
