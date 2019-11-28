class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_presence_of :first_name, :last_name, :username

  #has_many  :started_balances, :class_name => 'Balance', :foreign_key => 'balancer_1_id'
  #has_many  :added_to_balances, :class_name => 'Balance', :foreign_key => 'balancer_2_id'
  has_many :balances, as: :owner
  has_many :balances, as: :added_user
end
