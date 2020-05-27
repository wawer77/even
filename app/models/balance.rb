class Balance < ApplicationRecord
    attr_accessor :partner_id
    validates_presence_of :name
    #valdation turned off for update, as must provide partner_id(which exists already) when changing updated_by_id whenever transaction is created->
    validates_presence_of :partner_id, on: :create
    
    has_many :transactions, class_name: 'Transaction', foreign_key: 'balance_id', dependent: :delete_all
    has_and_belongs_to_many :users
    belongs_to :creator, class_name: 'User'
    belongs_to :editor, class_name: 'User'

    def partner_for(user)
        self.users.where.not(id: user.id).first
    end

    def change_updated_at_by(user)
        self.update(editor_id: user.id)
        #touch in case the update needs only date - updated_by_id remains the same and update rolls back, but returns true anyway
        self.touch
    end

    def even?
        (self.users.first.lended_value(self) == self.users.first.borrowed_value(self)) || false
    end
end
