class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.text :description
      t.float :value
      t.integer :issuer_id
      t.integer :receiver_id
      t.boolean :send_money
      t.integer :balance_id

      t.timestamps
    end
  end
end
