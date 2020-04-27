class Balance < ApplicationRecord
    attr_accessor :partner_id
    has_and_belongs_to_many :users
    validates_presence_of :name, :partner_id

    def partner_for(user)
        self.users.where.not(id: user.id).first
    end

    def transactions
        Transaction.where(balance_id: self.id)
    end

    def creator
        User.find(self.creator_id)
    end
end
