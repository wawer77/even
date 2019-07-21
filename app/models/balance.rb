class Balance < ApplicationRecord
  belongs_to :balancer_1, :class_name => 'User'
  belongs_to :balancer_2, :class_name => 'User'
end
