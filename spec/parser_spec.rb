require_relative 'spec_helper'
require_relative '../lib/parser'

RSpec.describe Parser do
  # TODO change this
  let(:str) { "Title here\n\nDescription here\n\n and here" }

  it 'works' do
    thought = Parser.parse(str).first

    expect(thought[:title]).to eq 'Title here'
    expect(thought[:description]).to eq "Description here\n\n and here"
  end

  it 'can have no description' do
    thought = Parser.parse("Title only\n").first

    expect(thought[:description]).to be_nil
  end

  context 'several thoughts' do
    let(:str) { "First thought\n===========\nAnother thought\n\nw/description" }

    it 'works' do
      thoughts = Parser.parse(str)

      expect(thoughts.first[:title]).to eq 'First thought'
      expect(thoughts.last[:title]).to eq 'Another thought'
    end
  end
end
