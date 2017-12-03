class AddRankToUser < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :rank, :integer
    add_column :users, :total_points, :integer, default: 0

  end
end
