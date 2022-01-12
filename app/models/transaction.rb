class Transaction < ApplicationRecord
    enum status: { pending: 0, confirmed: 1 }
    #possible to define when created, but not edited later
    attr_readonly :balance_id, :creator_id
    validates_presence_of :balance_id
    validates :value, presence: true, numericality: { greater_than: 0 }
    validates :send_money, inclusion: { in: [ true, false ] }
    validate :receiver_other_than_issuer

    belongs_to :issuer, class_name: 'User'
    #optiona: true, because only Balance is provided and receiver_id is inferred from that in controller - if it's validated, then this error pops up, which is confusing
    belongs_to :receiver, class_name: 'User', optional: true
    belongs_to :creator, class_name: 'User'
    belongs_to :editor, class_name: 'User'
    belongs_to :balance #, foreign_key: :balance, class_name: 'Balance' 

    ##### These methods are used, as couldn't extend the relation to simply users - including both issuer and receiver
    def users
        user = []
        user << self.issuer
        user << self.receiver
    end

    def partner_for(user)
        partner_array = self.users - [user]
        partner_array.first
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

    # TODO - move to service object?
    def transaction_message(user)
        if self.lending_transaction?(user)
            "You lended: #{self.value}"
        else
            "You borrowed: #{self.value}"
        end
    end 

    def receiver_other_than_issuer
        if self.receiver_id == self.issuer_id 
            errors.add(:receiver, "cannot be the Issuer at the same time")
        end            
    end
end
