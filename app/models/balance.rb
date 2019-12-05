class Balance < ApplicationRecord
  #should not be optional!
  belongs_to :owner, class_name: 'User'
  belongs_to :added_user, class_name: 'User'
#  belongs_to :users, class_name: 'User'
end
