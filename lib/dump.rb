class Dump
  def initialize(str)
    @text = str
    raise 'Dump blank!' if str.blank?
  end

  def process
    attrs = parse
    attrs.map do |attrs| 
      create_thought(attrs)
    end
    #thought.tags << Tag.find_or_create_by(name: 'todo') if options[:todo]
  end

  private

    def parse
      attrs = Parser.parse(@text)
    end

    def create_thought(attrs)
      thought = Thought.create!(attrs)
      puts "Thought #{thought.id} created  -  " + thought.to_s
    end
end

