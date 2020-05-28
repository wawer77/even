class BalancePolicy < ApplicationPolicy
  def show?
    record_includes_user?
  end
  def update?
    record_includes_user?
  end

  def edit?
    update?
  end

  def destroy?
    record_includes_user?
  end

  def record_includes_user?
    record.users.include?(user)
  end
end
