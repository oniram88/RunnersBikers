class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :challenged_id
      t.integer :challenger_id
      t.integer :status
      t.integer :points

      t.timestamps
    end
  end
end
