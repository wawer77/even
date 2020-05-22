class TransactionPolicy < ApplicationPolicy
  def confirm?
    record.receiver_id == user.id
  end
end
