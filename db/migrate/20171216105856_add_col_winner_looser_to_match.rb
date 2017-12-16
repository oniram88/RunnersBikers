class AddColWinnerLooserToMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :winner_id, :integer
    add_column :matches, :looser_id, :integer


    add_index :matches, :winner_id
    add_index :matches, :looser_id

  end
end
