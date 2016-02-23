require_relative 'tag'

self.send(:log, 'Tag loaded') if self.respond_to? :log

class Thought < ActiveRecord::Base
  self.send(:log, 'Thought inherited from AR::Base') if self.respond_to? :log
  has_and_belongs_to_many :tags

  scope :created_today, -> { where("thoughts.created_at >= ?", Time.now.beginning_of_day) }
  # necessary to prefix created_at by table name to avoid ambiguity in case of joins with Tag


  validates :title, presence: true, allow_blank: false
  validates :description, length: {minimum: 1}, allow_nil: true

  before_save :parse_tags
  # TODO not really this class's responsibility
  
  def to_s
    self.title
  end

  def to_dumpfile
    str = self.title
    str += "\n\n" + self.description if self.description
    return str
  end

  protected

    def parse_tags
      found_tags = title.scan(/(?:\s|^)(?:#(?!\d+(?:\s|$)))(\w+)(?=\s|$)/i).flatten
      p found_tags
      found_tags.each do |tag_name|
        tag = Tag.find_or_create_by!(name: tag_name)
        self.tags << tag
      end
      # replace with map?
    end

end
