class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_presence_of :first_name, :last_name, :username

  has_many :own_balances, as: :owner, class_name: 'Balance'
  has_many :added_to_balances, as: :added_user, class_name: 'Balance'
end
