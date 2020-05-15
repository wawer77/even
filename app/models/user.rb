class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates_presence_of :first_name, :last_name, :username

  has_many :issued_transactions, foreign_key: :issuer, class_name: 'Transaction'
  has_many :received_transactions, foreign_key: :receiver, class_name: 'Transaction' 
  has_and_belongs_to_many :balances

  has_many :friendships, -> { where(status: "confirmed") }, dependent: :destroy
  has_many :friends, through: :friendships
  
  has_many :sent_invitations, ->(user) { where(status: "pending", invitor_id: user.id) }, foreign_key: :user, class_name: 'Friendship'
  has_many :received_invitations, ->(user) { where(status: "pending").where.not(invitor_id: user.id) }, foreign_key: :user, class_name: 'Friendship'


  #! TRY JOIN?
  #has_many :transactions, ->(user) { where("issuer_id = ? OR receiver_id = ?", user.id, user.id) }
  #not working as it cheks for transactions WHERE user_ud = user.id AND the conditions above
  #https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#module-ActiveRecord%3a%3aAssociations%3a%3aClassMethods-label-Customizing+the+query

  ####### This method is defined as couldn't extend the relation to get transactions including both types; 
  #This reutrn an array instead of Relation anyway (so cannot .where it) - don't remember what I meant by this tho
  def transactions
    Transaction.where( 'issuer_id = :id OR receiver_id = :id', id: "#{ self.id }" )
  end 
end
