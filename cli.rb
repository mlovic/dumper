$:.unshift File.dirname(__FILE__)

START_TIME = Time.new
def log_time(str)
  puts (Time.new - START_TIME).to_s + '  ' + str
end

require 'thor'
log_time 'Thor loaded'
require 'lib/editor_input'

# TODO problems loading this file without AR

ROOT = File.dirname(__FILE__)
DB_PATH = File.join(ROOT, 'db/dumper.sqlite3')

  require 'active_record'
  log_time 'AR loaded'
  require 'pp'

  require 'lib/thought'
  log_time 'Thought loaded'
  require 'lib/parser'
  require 'lib/dump'

  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DB_PATH)

  log_time 'AR established connection'

def init
  # TODO 
  #require 'active_record'
  #log_time 'AR loaded'
  #require 'pp'

  #require 'lib/parser'
  #require 'lib/dump'

  #ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DB_PATH)

  #log_time 'AR established connection'
end

class Dumper < Thor
  log_time 'Inherited from Thor'

  # TODO open vim before requires
  desc "dump TITLE", "create new thought"
  method_option :edit, aliases: '-e'
  def dump(str = nil, options = {})
    # TODO how to choose editor
    #if input = STDIN.gets
      #str = input
      #p str
    #end
    #exit
    unless str # change to ||= syntax
      editor = EditorInput.new
      # TODO problem with stout going to vim
      editor.start
      init
      str = editor.get_text
    end
    init # TODO only if necessary
    dump = Dump.new(str)
    dump.process
  end

  desc 'amend', 'amend last dump'
  def amend 
    thought = Thought.last

    editor_in = EditorInput.new(thought.to_dumpfile) # figure this out. use #to_s?
    editor_in.start
    init
    str = editor_in.get_text 

    return if str == thought.to_dumpfile
    dump = Dump.new(str)
    thought.delete
    dump.process
    # updating a thought. doesn't feel right
  end

  desc 'todo TITLE', 'same as dump but adds todo tag. Only works inline.'
  def todo(title = nil)
    dump(title, todo: true)
  end

  desc "list", "list all thoughts. Default is only from today."
  method_option :all, aliases: '-a'
  # TODO -a shouldn't take argument
  def list(tag = nil)
    # optimize later. Array of scopes as symbols? as lambdas?
    init
    thoughts = options[:all] ? Thought.unscoped : Thought.created_today 
    if tag
      #clean this up
      thoughts = Thought.joins(:tags).where(tags: {name: tag}).merge(thoughts)
      # does merge do intersection?
    end
    thoughts.each { |th| puts "\n" + th.created_at.strftime('%H:%M') + ' -  ' + th.to_s }
  end

  desc 'ls', 'alias for list command'
  def ls(tag = nil)
    list(tag)
  end

  default_task :dump

end
