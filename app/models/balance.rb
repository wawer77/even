class Balance < ApplicationRecord
    attr_accessor :partner_id
    has_and_belongs_to_many :users
    validates_presence_of :name
    #valdation turned off for update, as must provide partner_id(which exists already) when changing updated_by_id whenever transaction is created->
    validates_presence_of :partner_id, on: :create
    #has_many :transactions - try to make it work?

    def partner_for(user)
        self.users.where.not(id: user.id).first
    end

    def transactions
        Transaction.where(balance_id: self.id)
    end

    def creator
        User.find(self.creator_id)
    end

    def change_updated_at_by(user)
        self.update(updated_by_id: user.id)
        #touch in case the update needs only date - updated_by_id remains the same and update rolls back, but returns true anyway
        self.touch
    end
end
