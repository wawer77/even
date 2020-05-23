# Even
To stay even with your friends.

## CURRENT TO DO:

- Prevent from duplicating friendship requests

- Edit Balances (name description)

- Edit Transactions BEFORE confirmed (if edited by receiver, it should get reversed)

- Balance Delete buttons (only if 0 transactions)

- Balance archive buttons (only if even) -> make balance + all related transactions archived

- pagination for transactions index (with filtering by user/balance/archived)

- javascript for transaction/balance(?) forms

- Minor:

  - Transaction creation:
    lend money - if another input is incorrect - this is as 'is-valid' in html and green;
    borrow money - if another input is incorrect - nothing, input correct, but no 'is-valid' div class

  - use simple form + form fixes
    - Login - when wrong username input - The field turns green with a tick-sign (should be red note or whatever) -> input class turns '= is-valid'
    - User registration simple_form not working properly - doesn't ask for the '@' in e-mail straightaway 
      - Doesn't check for . after @ - add it

  - make bootstrap icons working

  - Further changes:    
      - New User: Make fields work properly
      - searchbar for users and balances
      - Navbar: highlight My Balances tab, when on page: balance/id

## Description
App for managing debts. Users share balances with their friends. That allows them to add transactions, where they specify how much they lended or borrowed. Users can crate unlimited number of balances with the same friend. Each transaction must be confirmed by the second party before it gets added to the balance, but when confirmed - it cannot be deleted. Each balance can be archived when its status is "Even". Transactions become archived together with the balance they correspond to and can be viewed by both users. Users can remove others form their friends list, but only when the overall status with them is "Even". 

## For future development
- Add test suite.
- Relocation of debts (eg. A owes 5 to B, B 5 to C, C 5 to A => debts are cancelled).
- Groups sharing one debt: model groups with users.

## Ruby / Rails version:
2.5.1p57 / Rails 5.2.4.2

## Configuration
- Clone the repo.
- Install needed gems:
```
$ bundle install
```
- Configure user and password in database.yml if needed.
- Create and migrate the database
```
$ rake db:create
$ rake db:migrate
```