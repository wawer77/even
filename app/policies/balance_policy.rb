class BalancePolicy < ApplicationPolicy
  def destroy?
    record.users.include?(user)
  end
end
