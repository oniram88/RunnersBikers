class AddColumnNoteToMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :note, :text
  end
end
