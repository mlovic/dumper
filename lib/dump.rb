class Dump
  HASHTAG_REGEX = /(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i
  def initialize(str)
    @text = str
    raise 'Dump blank!' if str.blank?
  end

  def process
    attrs = parse
    attrs.map do |attrs| 
      thought = create_thought(attrs)
      create_tags(thought)
    end
  end

  private

    def create_tags(thought)
      found_tags = thought.text.scan(HASHTAG_REGEX).flatten
      found_tags.each do |tag_name|
        tag = Tag.find_or_create_by!(name: tag_name)
        thought.tags << tag
      end
    end

    def parse
      attrs = Parser.parse(@text)
    end

    def create_thought(attrs)
      thought = Thought.create!(attrs)
      puts "Thought #{thought.id} created  -  " + thought.to_s
      return thought
    end
end

