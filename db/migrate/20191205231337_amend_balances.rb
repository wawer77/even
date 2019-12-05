class AmendBalances < ActiveRecord::Migration[5.2]
  def change
    drop_table :balances
    create_table :balances do |t|
        t.string :name
        t.text :description
        t.float :value
        t.integer :owner_id
        t.integer :added_user_id
      t.timestamps
    end
  end
end
