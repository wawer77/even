# Even
To stay even with your friends.

## CURRENT TO DO:
- Continue with Friendship confrimation 

- Resolve Transaction validation problem

- pagination for transactions index (with filtering by user/balance)

- Figure out: what to do in case of Balance deletion? - because those transactions will be visible - do we push them to Default balance or make status field(?) or keep the balance as 'closed' and then transactions are as historic and available thru some 'historic' filter in Transaction index (could be the best soultion - only Balances with 0 transactions could be deleted then, which makes sense); in addition - only even Balances could be set as closed

- Transaction creation:
  lend money - if another input is incorrect - this is as 'is-valid' in html and green;
  borrow money - if another input is incorrect - nothing, input correct, but no 'is-valid' div class

- use simple form + form fixes
  - Login - when wrong username input - The field turns green with a tick-sign (should be red note or whatever) -> input class turns '= is-valid'
  - User registration simple_form not working properly - doesn't ask for the '@' in e-mail straightaway 
    - Doesn't check for . after @ - add it

- make bootstrap icons working

- Further changes:    
    - New: Make fields work properly
    - searchbar for users and balances
    - Navbar: highlight My Balances tab, when on page: balance/id

## Known issues suspended for now:
- gem sass is deprecated, therefore need for sassc and rails-sassc?

## Description
App for managing debts between users. Every user has a dashboard with balances list - every with another user/ Every change made to the balance must be accepted.

## For future development
- Relocation of debts (eg. A owes 5 to B, B 5 to C, C 5 to A => debts are cancelled).
- Groups sharing one debt: model groups with users; automatically assigned even values

## Features:
- admin dashboard?
- users index?
- users have private dashboard with balance list
- users have official profile to be viewed by others

- each change having 2 status columns: for user A and B
  - A sends a debt to B - A: sent, B:pending
  - B accepts: accepted-both and added to balance (+ or -)
  - B rejects: rejected
- Button to make the balance 0

## Models:

## UI:

## Refactor TODOS:

## To figure out:

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
