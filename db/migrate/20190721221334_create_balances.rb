class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.references :balancer_1
      t.references :balancer_2
      t.float :balancer_1_debt
      t.float :balancer_2_debt

      t.timestamps
    end

    add_foreign_key :balances, :users, column: :balancer_1_id, primary_key: :id
    add_foreign_key :balances, :users, column: :balancer_2_id, primary_key: :id
  end
end
