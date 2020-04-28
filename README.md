# Even
To stay even with your friends.

## CURRENT TO DO:

- Continue adding transactions to balance show view

- Add logics for:
  - transaction with users
  - transactions grouped into balances

- Add transaction to balance button in balance with predefined transaction.balance_id  

- Transaction creation:
  lend money - if another input is incorrect - this is as 'is-valid' in html and green;
  borrow money - if another input is incorrect - nothing, input correct, but no 'is-valid' div class

- use simple form + form fixes
  - Login - when wrong username input - The field turns green with a tick-sign (should be red note or whatever) -> input class turns '= is-valid'
  - User registration simple_form not working properly - doesn't ask for the '@' in e-mail straightaway 
    - Doesn't check for . after @ - add it

- Further changes:    
    - New: Make fields work properly
    - searchbar for users and balances
    - Navbar: highlight My Balances tab, when on page: balance/id

## Known issues suspended for now:
- gem sass is deprecated, therefore need for sassc and rails-sassc

## Description
App for managing debts between users. Every user has a dashboard with balances list - every with another user/ Every change made to the balance must be accepted.

## For future development
- Relocation of debts (eg. A owes 5 to B, B 5 to C, C 5 to A => debts are cancelled).
- Groups sharing one debt: model groups with users; automatically assigned even values - modifiable

## Features:
- admin dashboard - administrate gem
- users index?
- users have private dashboard with balance list
- users have official profile to be viewed by others

- each balance can be changed by a user adding or removing to/from it
- each change having 2 status columns: for user A and B
  - A sends a debt to B - A: sent, B:pending
  - B accepts: accepted-both and added to balance (+ or -)
  - B rejects: rejected
- Button to make the balance 0
- changes moved to history

## Models:
- users - Devise; seen as balancers - 2 for each balance
- balance

## UI:

## Refactor TODOS:

## To figure out:
- Any gem for accounts/balance
- Gem for searching users
- Gem for keeping history of posts - every change?

- Any gem for friends?

## Ruby/Rails version:
2.5.1/5.2.1

## Configuration
- clone
- run bundle install

## Database
- configure user and password in database.yml if needed
- run: rake db:create, rake db:migrate

## Test suite
## Deployment instructions

## Comments
- Used relationship: https://stackoverflow.com/questions/49605108/adding-multiple-users-into-a-single-record-rails-5
