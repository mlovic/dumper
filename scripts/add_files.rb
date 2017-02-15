require_relative 'lib/dump'
def lines(f)
  ls = []
  f.each_line { |l| ls << l }
  ls
end

@thoughts = []
Dir.glob('/home/marko/Downloads/dump/dump/*') do |file_path|
  file = File.new file_path
  lines = lines(file)
  file.close
  ts = Time.at(lines.pop.strip.to_i)
  body = lines.join.strip
  file_name = file_path.split('/').last.strip
  @thoughts << {body:  body,
                ts:    ts,
                title: file_name}
end

@thoughts.sort_by! { |t| t[:ts] }

@thoughts.each do |th|
  dump = Dump.new(th[:body], timestamp: th[:ts], title: th[:title])
  dump.process
end
