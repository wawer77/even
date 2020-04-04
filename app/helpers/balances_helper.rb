module BalancesHelper

  def otheruser(balance)
      if balance.owner_id == current_user.id
        User.find(balance.added_user_id).username
      else
        User.find(balance.owner_id).username
      end
    end

  def situation(balance)
   if balance.owner_id == current_user.id
      if balance.value > 0
       statement="You lended"
      elsif balance.value < 0
        statement="You owe"
      else
        statement="You are even!"
      end
    else
      if balance.value > 0
        statement="You owe"
      elsif balance.value < 0
        statement="You lended"
      else
        statement="You are even!"
      end
    end
    statement + " " + (balance.value unless balance.value == 0).to_s
  end

end
