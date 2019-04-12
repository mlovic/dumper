class EditorInput
  # TODO figure out editor
  attr_reader :started_at

  def initialize(starting_text = nil, editor: Editor)
    @file = Tempfile.new("buffer")
    @text = starting_text
    write_to_buffer(starting_text) if starting_text
  end

  def start
    @started_at = Time.now
    @pid = spawn_editor
  end
    
  def get_text
    Process.wait(@pid) # probs shouldn't belong here 
    str = File.read(path)
  end

  private

    def spawn_editor
      editor.spawn(path, insert_mode: new_note?)
    end

    def write_to_buffer(text)
      @file.write(text)
      @file.close
    end

    def editor
      @editor || Editor
    end

    def path
      @file.path
    end

    def new_note?
      !@text
    end
end

class Editor
  # prompt
  # start with i
  # insert mode

  # returns PID of editor process
  def self.spawn(path, insert_mode: false)
    pid = Kernel.spawn("vim #{ "+star" if insert_mode } #{path}")
  end

end
