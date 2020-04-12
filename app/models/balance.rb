class Balance < ApplicationRecord
    attr_accessor :partner_id
    has_and_belongs_to_many :users
    validates_presence_of :name, :partner_id
end
