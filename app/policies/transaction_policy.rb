class TransactionPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end
  
  def confirm?
    record.editor != user && record.users.include?(user)
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
