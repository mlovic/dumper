require_relative 'spec_helper'
require_relative '../cli'
require_relative '../lib/dump'

# TODO fix this. ar_init was removed with the rest of old AR code
require_relative 'ar_init'
 
RSpec.describe Dumper do
  let(:thought) { Thought.new(id: 4, title: 'sample title', description: 'desc') }

  before do
    editor = EditorInput.new
    allow(EditorInput).to receive(:new) { editor }
    allow(editor).to receive(:get_text) { 'title here' }
  end

  describe 'dump' do
    it 'creates post' do
      attrs = { title: 'title here', description: nil }
      expect(Thought).to receive(:create!).with(attrs) { thought }

      Dumper.new.dump('title here')
    end

    it 'takes editor input' do
      attrs = { title: 'title here', description: nil }

      expect(Thought).to receive(:create!).with(attrs) { thought }

      Dumper.new.dump
    end

    it 'parses tags' do
      Dumper.new.dump('title here #test')

      expect(Tag.count).to eq 1
      expect(Tag.take.name).to eq 'test'
      expect(Thought.last.tags.first.name).to eq 'test'
    end
  end

  describe 'amend' do
    it 'changes last post in db' do
      Thought.delete_all

      thought.save

      Dumper.new.amend

      expect(Thought.last.title).to eq 'title here'
    end
    
  end
end
