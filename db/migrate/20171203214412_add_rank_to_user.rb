class AddRankToUser < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :rank, :integer
    add_column :users, :total_points, :integer, default: 0


    reversible do |dir|
      dir.up do

        User.all.each do |u|
          u.update_points
          u.update_rank
        end

      end
    end
  end
end
