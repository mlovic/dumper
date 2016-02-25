class EditorInput
  # TODO figure out editor
  def initialize(starting_text = nil, editor: Editor)
    @file = Tempfile.new("buffer")
    @text = starting_text
    write_to_buffer(starting_text) if starting_text
  end
    
  def get_text
    spawn_editor
    str = File.read(path)
  end

  private

    def spawn_editor
      editor.spawn(path, insert_mode: new_thought?)
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

    def new_thought?
      !@text
    end
end

class Editor
  # prompt
  # start with i

  def self.spawn(path, insert_mode: false)
    pid = Kernel.spawn("vim #{ "+star" if insert_mode } #{path}")
    Process.wait(pid) # probs shouldn't belong here 
  end

end
