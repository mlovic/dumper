#require "sinatra/activerecord"

class Tag < ActiveRecord::Base
  self.send(:log, 'Tag inherited from AR::Base') if self.respond_to? :log
  has_and_belongs_to_many :tags

  validates :name, presence: true

end
