class CreateCategoryTags < ActiveRecord::Migration
  def change
    create_table :category_tags do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :category_tags, :user_id
  end
end
