class AddFromEmailComlumnToThoughts < ActiveRecord::Migration
  def change
    add_column :thoughts, :from_email, :boolean, default: false
  end
end
