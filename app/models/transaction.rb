class Transaction < ApplicationRecord
    attr_accessor :balance_name
    validates_presence_of :issuer_id, :receiver_id, :value 
    validates :send_money, inclusion: { in: [ true, false ] }
end
