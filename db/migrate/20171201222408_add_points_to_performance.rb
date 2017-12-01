class AddPointsToPerformance < ActiveRecord::Migration[5.1]
  def change

    add_column :performances, :points, :integer


    Performance.all.each do |p|
      p.save
    end

  end
end
