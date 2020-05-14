class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :friend
      t.string :status
      t.integer :invitor_id

      t.timestamps
    end
  end
end
