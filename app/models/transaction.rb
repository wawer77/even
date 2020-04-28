class Transaction < ApplicationRecord
    attr_accessor :balance_name
    validates_presence_of :issuer_id, :receiver_id, :value 
    validates :send_money, inclusion: { in: [ true, false ] }

    belongs_to :issuer, class_name: 'User'
    belongs_to :receiver, class_name: 'User'

    ##### These methods are used, as couldn't extend the relation to simply users - including both issuer and receiver
    def users
        user = []
        user << self.issuer
        user << self.receiver
    end

    def partner_for(user)
        partner_arr = self.users - [user]
        partner_arr.first
    end
    ###############

    def lending_transaction?(user)
        partner = self.partner_for(user)
        if (self.issuer_id == user.id && self.send_money == true) || (self.issuer_id == partner.id && self.send_money == false)
            true
        else
            false
        end
    end

    def borrowing_transaction?(user)
        if lending_transaction?(user) == true
            false
        else
            true
        end
    end
end
