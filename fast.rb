#!/usr/bin/env ruby

start = Time.now
$start = Time.now

#puts "%ss to load" % (Time.now - start)
$:.unshift File.dirname(__FILE__)
#puts "%ss to load" % (Time.now - start)
puts "%ss to load" % (Time.now - start)
require_relative 'lib/dump'
puts "%ss to load" % (Time.now - start)
require_relative 'lib/editor_input'
puts "%ss to load" % (Time.now - start)
require 'pp'
puts "%ss to load" % (Time.now - start)
require 'tempfile'
puts "%ss to load" % (Time.now - start)


editor = EditorInput.new

# TODO problem with stout going to vim

editor.start

require 'net/http'
require 'mongo'
#puts "%ss to load" % (Time.now - start)

str = editor.get_text

dump = Dump.new(str, timestamp: Time.now,
                     editor_opened_at: editor.started_at)
dump.process
