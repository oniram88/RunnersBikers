class CreatePerformances < ActiveRecord::Migration[5.1]
  def change
    create_table :performances do |t|
      t.integer :user_id
      t.decimal :distance, precision: 8, scale: 4
      t.integer :pace
      t.integer :positive_gain
      t.string :url

      t.timestamps
    end
  end
end
