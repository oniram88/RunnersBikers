class AddRankToUser < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :rank, :float

  end
end
