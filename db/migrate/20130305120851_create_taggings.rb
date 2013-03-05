class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :interior
      t.references :category_tag

      t.timestamps
    end
    add_index :taggings, :interior_id
    add_index :taggings, :category_tag_id
  end
end
