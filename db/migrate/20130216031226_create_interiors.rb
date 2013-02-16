class CreateInteriors < ActiveRecord::Migration
  def change
    create_table :interiors do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :interiors, :user_id
  end
end
