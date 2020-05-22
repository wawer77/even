class AddStatusToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :status, :integer, default: '0'
    change_column :friendships, :status, :integer, default: '0'
  end
end
