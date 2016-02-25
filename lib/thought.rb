require_relative 'tag'

self.send(:log, 'Tag loaded') if self.respond_to? :log

class Thought < ActiveRecord::Base
  self.send(:log, 'Thought inherited from AR::Base') if self.respond_to? :log
  has_and_belongs_to_many :tags

  scope :created_today, -> { where("thoughts.created_at >= ?", Time.now.beginning_of_day) }
  # necessary to prefix created_at by table name to avoid ambiguity in case of joins with Tag


  validates :title, presence: true, allow_blank: false
  validates :description, length: {minimum: 1}, allow_nil: true
  
  def to_s
    self.title
  end

  def text
    str = self.title
    str += "\n\n" + self.description if self.description
    return str
  end

  def to_dumpfile
    str = self.title
    str += "\n\n" + self.description if self.description
    return str
  end

  protected

end
