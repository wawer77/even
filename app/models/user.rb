class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates_presence_of :first_name, :last_name, :username

  has_many :issued_transactions, foreign_key: :issuer, class_name: 'Transaction'
  has_many :received_transactions, foreign_key: :receiver, class_name: 'Transaction' 
  has_and_belongs_to_many :balances

  ####### This method is defined as couldn't extend the relation to get transactions including both types; This reutrn an array instead of Relation anyway (so cannot .where it)
  def transactions
    Transaction.where( 'issuer_id = :id OR receiver_id = :id', id: "#{ self.id }" )
  end 
end
