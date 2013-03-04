class AddMemoTextToInteriorHistories < ActiveRecord::Migration
  def change
    add_column :interior_histories, :memo_text, :text
  end
end
