class CreateThoughts < ActiveRecord::Migration
  def change
    create_table :thoughts do |t|
      t.string :title
      t.text :description
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :tags_thoughts, id: false do |t|
      t.integer :thought_id, index: true
      t.integer :tag_id, index: true
    end
  end
end
