class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :balances, :updated_by_id, :editor_id
    rename_column :transactions, :updated_by_id, :editor_id
  end
end
