class CreateInteriorHistories < ActiveRecord::Migration
  def change
    create_table :interior_histories do |t|
      t.date :start_date
      t.float :width
      t.float :height
      t.float :depth
      t.references :interior

      t.timestamps
    end
    add_index :interior_histories, :interior_id
  end
end
