class FriendshipPolicy < ApplicationPolicy
  def confirm?
    record.user_id == user.id && record.user_id != record.invitor_id
  end

  def destroy?
    record.user_id == user.id
  end
end
