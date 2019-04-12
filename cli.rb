$:.unshift File.dirname(__FILE__)

START_TIME = Time.new
def log_time(str)
  puts (Time.new - START_TIME).to_s + '  ' + str
end

require 'thor'
log_time 'Thor loaded'
require 'lib/editor_input'
require 'pp'
require 'lib/dump'

# TODO problems loading this file without AR
#
# TODO remove all old AR stuff

ROOT = File.dirname(__FILE__)

class Dumper < Thor
  log_time 'Inherited from Thor'

  # TODO open vim before requires
  desc "dump TITLE", "create new note"
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
      #init
      str = editor.get_text
    end
    #init # TODO only if necessary
    dump = Dump.new(str)
    dump.process
  end

  desc 'todo TITLE', 'same as dump but adds todo tag. Only works inline.'
  def todo(title = nil)
    #dump(title, todo: true)
    puts 'Not implemented yet'
  end

  desc "list", "list all notes. Default is only from today."
  method_option :all, aliases: '-a'
  # TODO -a shouldn't take argument
  def list(tag = nil)
  end

  desc 'ls', 'alias for list command'
  def ls(tag = nil)
    list(tag)
  end

  default_task :dump
end
