class AddColumnReferalPointsToUser < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :referal_points, :integer, default: 0

  end
end
