class AddUpdatedByIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :updated_by_id, :integer
  end
end
