module TransactionsHelper
    def partner_or_current_user(user)
        if user == current_user
            "You"
        else
            user.username
        end
    end
end
