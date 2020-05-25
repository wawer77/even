class AddCreatorIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :creator_id, :integer
  end
end
