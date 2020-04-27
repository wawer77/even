class AddCreatorIdToBalances < ActiveRecord::Migration[5.2]
  def change
    add_column :balances, :creator_id, :integer
  end
end
