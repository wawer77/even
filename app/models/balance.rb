class Balance < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :added_user, class_name: 'User'
end
