class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
        t.string :name
        t.text :description
        t.float :value
        t.references :owner, polymorphic: true
        t.references :added_user, polymorphic: true
      t.timestamps
    end
  end
end
