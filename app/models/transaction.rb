class Transaction < ApplicationRecord
    validates_presence_of :issuer_id, :receiver_id, :value, :send_money 
end
