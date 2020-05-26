class TransactionPolicy < ApplicationPolicy
  def confirm?
    record.users.include?(user) && record.updated_by_id != user.id
  end

  def update?
    record.status == 'pending'
  end

  def edit?
    update?
  end

  def destroy?
    record.status == 'pending' && record.creator == user
  end
end
