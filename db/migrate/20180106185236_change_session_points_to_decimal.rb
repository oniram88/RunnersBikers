class ChangeSessionPointsToDecimal < ActiveRecord::Migration[5.1]
  def change

    change_column :performances, :points, :decimal, :precision => 15, :scale => 3
    change_column :users, :total_points, :decimal, :precision => 15, :scale => 3

  end
end
