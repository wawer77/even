## Even
To stay even with your friends.

# Description
App for managing debts between users. Every user has a dashboard with balance and list of debts (their and others'). Every debt/even sent to a user must be accepted.

# For future development
- Relocation of debts (eg. A owes 5 to B, B 5 to C, C 5 to A => debts are cancelled).
- Groups sharing one debt: model groups with users; automatically assigned even values - modifiable

# Features:
- admin dashboard - administrate gem
- users index
- users have private dashboard with balance and debts
- users have official profile to be viewed by others

- each debt may be sent as "my or their debt"
- each debt having 2 status columns: for user A and B
  - A sends a debt to B - A: sent, B:pending
  - B accepts: accepted-both and added to balance (+ or -)
  - B rejects: rejected
  - B amends: A:pending B:sent  
- debts may be marked as paid by both: A:paid B:pay_pending or <-> pending?
- debts moved to history

# Models:
- users - Devise; has_many:posts, balance:integer?,
- post - belongs_to: users; value:integer; date_of_debt:date; comment:text,
        eml: status_sender, status_receiver,

# UI:
- Bootstrap -> formatting

# Refactor TODOS:

# To figure out:
- Any gem for accounts/balance
- Gem for searching users
- Gem for keeping history of posts - every change?

- Any gem for friends?

# Ruby/Rails version:
2.5.1/5.2.1

# Configuration
- clone
- run bundle install

# Database
- configure user and password in databse.yml if needed
- run db:create, db:migrate

# Test suite
# Deployment instructions
