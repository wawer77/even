class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates_presence_of :first_name, :last_name, :username

  has_many :transactions
  has_and_belongs_to_many :balances

  def issued_transactions
      Transaction.where(issuer_id: self.id)
  end

  def received_transactions
      Transaction.where(receiver_id: self.id)
  end
end
