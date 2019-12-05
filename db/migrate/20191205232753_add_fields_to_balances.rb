class AddFieldsToBalances < ActiveRecord::Migration[5.2]
  def change
    add_column :balances, :owner_type, :string
    add_column :balances, :added_user_type, :string
  end
end
