class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_join_table :balances, :users do |t|
      t.index :balance_id
      t.index :user_id
    end

  end
end
