class AddUpdatedByIdToBalances < ActiveRecord::Migration[5.2]
  def change
    add_column :balances, :updated_by_id, :integer
  end
end
