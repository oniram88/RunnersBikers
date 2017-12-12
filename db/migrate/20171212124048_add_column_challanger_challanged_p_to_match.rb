class AddColumnChallangerChallangedPToMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :challenger_p_id, :integer
    add_column :matches, :challenged_p_id, :integer
    add_column :matches, :judge_id, :integer
  end
end
