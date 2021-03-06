class Parser
  def initialize(str)
    @str = str
  end

  def self.parse(str)
    new(str).parse
  end

  def parse
    # TODO fix
    dumps = get_individual_dumps(@str)
    dumps.map { |dump| parse_note(dump) }
  end

  def separator
    /^[-=]{2,}/
  end

  def get_individual_dumps(str)
    str.split(separator)
  end

  def parse_note(dump)
    title, desc = dump.strip.split("\n", 2).map(&:strip)
    attrs = {title: title, description: desc}
    return attrs
  end

end
