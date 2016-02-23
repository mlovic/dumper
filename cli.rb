START_TIME = Time.new
def log(str)
  puts (Time.new - START_TIME).to_s + '  ' + str
end

require 'active_record'
require 'logger'

log 'AR loaded'

$:.unshift File.dirname(__FILE__)


require 'thor'
log 'Thor loaded'
require 'lib/thought'
require 'lib/parser'

DB_PATH = '/home/marko/dumper/dumper.sqlite3'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DB_PATH)

log 'AR established connection'

class Dumper < Thor
  log 'Inherited from Thor'
  #include Thor::Actions # necessary?

  # TODO open vim before requires
  desc "dump TITLE", "create new thought"
  method_option :edit, aliases: '-e'
  def dump(title = nil, options = {})
    if title
      thought = Thought.new(title: title)
      thought.tags << Tag.find_or_create_by(name: 'todo') if options[:todo]
      thought.save!
      puts "Thought #{thought.id} created  -  " + thought.to_s
    else
      file = Tempfile.new("buffer")
      path = file.path
      pid = spawn("vim +star #{path}")
      Process.wait(pid)
      str = File.read(path)
      raise 'File blank!' if str.blank?
      attrs = Parser.parse(str)
      attrs.map do |attrs| 
        thought = Thought.create!(attrs)
        puts "Thought #{thought.id} created  -  " + thought.to_s
      end
    end
  end

  desc 'amend', 'amend last dump'
  def amend 
    thought = Thought.last

    file = Tempfile.new("buffer")
    p thought.to_dumpfile
    file.write(thought.to_dumpfile)
    file.close
    # TODO Abstract to get_from_vim method passing default test as arg
    path = file.path
    pid = spawn("vim #{path}")
    Process.wait(pid)
    str = File.read(path)
    return if str == thought.to_dumpfile
    attrs = Parser.parse(str)
    thought.update(attrs.shift)
    attrs.map do |attrs| 
      thought = Thought.create!(attrs)
      puts "Thought #{thought.id} created  -  " + thought.to_s
    end
  end

  #def vim(path)
  #end

  desc 'todo TITLE', 'same as dump but adds todo tag. Only works inline.'
  def todo(title = nil)
    dump(title, todo: true)
  end

  desc "list", "list all thoughts. Default is only from today."
  method_option :all, aliases: '-a'
  def list(tag = nil)
    # optimize later. Array of scopes as symbols? as lambdas?
    thoughts = options[:all] ? Thought.unscoped : Thought.created_today 
    if tag
      #clean this up
      thoughts = Thought.joins(:tags).where(tags: {name: tag}).merge(thoughts)
    end
    thoughts.each { |th| puts th.created_at.strftime('%H:%M') + ' -  ' + th.to_s }
  end

  desc 'ls', 'alias for list command'
  def ls(tag = nil)
    list(tag)
  end

  default_task :dump

end
