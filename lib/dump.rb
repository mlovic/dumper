require_relative 'remote_dump'
require 'mongo'

puts "%ss to load" % (Time.now - $start)
#require 'mongo'
puts "%ss to load" % (Time.now - $start)

class Dump
  HASHTAG_REGEX = /(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i

  def initialize(str, timestamp: nil, title: nil, editor_opened_at: nil)
    @text = str
    @timestamp = timestamp
    @editor_opened_at = editor_opened_at
    @title = title
    abort('Dump blank!') if str == ''
  end

  def process
    # TODO send title too?
    puts RemoteDump.new(@text).call rescue puts "Error making remote call: #{$!}"
    tags = create_tags(@text)
    note = {body: @text,
            tags: tags,
            num: next_num,
            title: @title,
            editor_opened_at: @editor_opened_at }
    persist_note(note)
  end

  private

    def client
        @client ||= Mongo::Client.new([ '127.0.0.1:27017' ], database: 'dump')
    end

    def next_num
      (client[:notes].find({}, {num: 1}).sort({num: -1}).limit(1).first['num'] + 1).to_i
    end

    def persist_note(note)
      client[:notes].insert_one(note.merge(make_timestamps)
                                          .merge(archived: false))
      puts "Note #{note[:num]} created"
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

