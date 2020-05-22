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


  # TODO - TRY JOIN?
  #has_many :transactions, ->(user) { where("issuer_id = ? OR receiver_id = ?", user.id, user.id) }
  #not working as it cheks for transactions WHERE user_ud = user.id AND the conditions above
  #https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#module-ActiveRecord%3a%3aAssociations%3a%3aClassMethods-label-Customizing+the+query

  ####### This method is defined as couldn't extend the relation to get transactions including both types; 
  #This reutrn an array instead of Relation anyway (so cannot .where it) - don't remember what I meant by this tho
  def transactions
    Transaction.where( 'issuer_id = :id OR receiver_id = :id', id: "#{ self.id }" )
  end 
 
  def transactions_with(user)
    self.transactions.where('issuer_id = :id OR receiver_id = :id', id: "#{ user.id }")
  end 

  def balances_with(user)
    (self.balances.to_a) & (user.balances.to_a)
  end

  def friends_with?(user)
    true if self.friends.include?(user)
  end

  def friendship_with(user)
    self.friendships.where(friend_id: user.id)
  end

  def invitation_sent_to(user)
    self.sent_invitations.find_by(friend_id: user.id)
  end

  def invitation_received_from(user)
    self.received_invitations.find_by(invitor_id: user.id)
  end

  #if more than one Balance, must be an array!
  def lending_transactions(balances={})
    if balances.blank?
      nil
    elsif balances == "all"  
      #all transactions
      transactions = []
      transactions = self.transactions.confirmed.where(["issuer_id = ? and send_money = ?", self.id, 'true']) + self.transactions.confirmed.where(["issuer_id != ? and send_money = ?", self.id, 'false'])
    else
      #only for balances indicated in the parameter
      #if input is single Balance, make it Array, if not - leave it, as more than one Balance input should be an Array
      balances = [balances] if balances.class != Array
      transactions = []
      balances.each do |balance|
        balance_transactions = balance.transactions.confirmed.where(["issuer_id = ? and send_money = ?", self.id, 'true']) + balance.transactions.confirmed.where(["issuer_id != ? and send_money = ?", self.id, 'false'])
        transactions += balance_transactions
      end      
    end
    transactions.sort if transactions != nil
  end

  #if more than one Balance, must be an array!
  def borrowing_transactions(balances={})
    if balances.blank?
      nil
    elsif balances == "all" 
      #all transactions
      transactions = []
      transactions = self.transactions.confirmed.where(["issuer_id = ? and send_money = ?", self.id, 'false']) + self.transactions.confirmed.where(["issuer_id != ? and send_money = ?", self.id, 'true'])
    else
      #only for balances indicated in the parameter
      #if input is single Balance, make it Array, if not - leave it, as more than one Balance input should be an Array
      balances = [balances] if balances.class != Array
      transactions = []
      balances.each do |balance|
        balance_transactions = balance.transactions.confirmed.where(["issuer_id = ? and send_money = ?", self.id, 'false']) + balance.transactions.confirmed.where(["issuer_id != ? and send_money = ?", self.id, 'true'])
        transactions += balance_transactions 
      end      
    end
    transactions.sort if transactions != nil
  end

  def lended_value(balances={})
    lended_value = 0
    if balances.blank?
      lended_value
    else
      self.lending_transactions(balances).each do |transaction|
        lended_value += transaction.value   
      end
    end
    lended_value
  end

  def borrowed_value(balances={})
    borrowed_value = 0
    if balances.blank?
      borrowed_value
    else
      self.borrowing_transactions(balances).each do |transaction|
        borrowed_value += transaction.value   
      end
    end
    borrowed_value
  end
end
