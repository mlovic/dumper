require_relative 'remote_dump'
require 'mongo'

puts "%ss to load" % (Time.now - $start)
#require 'mongo'
puts "%ss to load" % (Time.now - $start)

class Dump
  HASHTAG_REGEX = /(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i

  def initialize(str, timestamp: nil, title: nil)
    @text = str
    @timestamp = timestamp
    @title = title
    abort('Dump blank!') if str == ''
  end

  def process
    # TODO send title too?
    puts RemoteDump.new(@text).call rescue puts "Error making remote call: #{$!}"
    tags = create_tags(@text)
    thought = {body: @text, tags: tags, num: next_num, title: @title}
    persist_thought(thought)
  end

  private

    def client
        @client ||= Mongo::Client.new([ '127.0.0.1:27017' ], database: 'dump')
    end

    def next_num
      @num = client[:thoughts].find({}, {num: 1}).sort({num: -1}).limit(1).first['num'] + 1
    end

    def persist_thought(thought)
      client[:thoughts].insert_one(thought.merge(make_timestamps)
                                          .merge(archived: false))
      puts "Thought #{@id} created"
    end

    def make_timestamps
      # TODO what to do about tz?
      ts = @timestamp || Time.now
      {created_at: ts, updated_at: ts}
    end

    def create_tags(str)
      found_tags = str.scan(HASHTAG_REGEX).flatten
    end
end

