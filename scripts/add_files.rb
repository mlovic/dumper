#require_relative 'lib/dump'
$start = Time.now

require 'pp'

require 'lib/dump'

@thoughts = []
Dir.glob('/home/marko/*_dump') do |file_path|
  file = File.new(file_path)
  file_name = file_path.split('/').last.strip
  @thoughts << {body:  file.read.strip,
                ts:    file.ctime,
                title: file_name}
end

@thoughts.sort_by! { |t| t[:ts] }

@thoughts.each do |th|
  #pp th
  #require 'irb'
  #binding.irb
  dump = Dump.new(th[:body], timestamp: th[:ts], title: th[:title])
  dump.process
end
