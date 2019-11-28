class Balance < ApplicationRecord
  #should not be optional!
  belongs_to :owner, polymorphic: true, optional: true
  belongs_to :added_user, polymorphic: true, optional: true
end
