# Even
To stay even with your friends.

## CURRENT TO DO:

- Balance archive buttons (only if even) -> make balance + all related transactions archived

- Sort balances transactions on???

- Minor:

  - Transaction creation:
    lend money - if another input is incorrect - this is as 'is-valid' in html and green;
    borrow money - if another input is incorrect - nothing, input correct, but no 'is-valid' div class

  - use simple form + form fixes
    - Login - when wrong username input - The field turns green with a tick-sign (should be red note or whatever) -> input class turns '= is-valid'
    - User registration simple_form not working properly - doesn't ask for the '@' in e-mail straightaway 
      - Doesn't check for . after @ - add it

  - When editin (e.g. Balance) - pre-populated forms turn green
    https://stackoverflow.com/questions/51848531/rails-simple-form-gem-is-adding-a-green-border-to-inputs-that-are-pre-populated

  - Further changes:    
      - New User: Make fields work properly
      - Navbar: highlight My Balances tab, when on page: balance/id

## Description
App for managing debts. You simply create balances with other Users, who must be your frirends. That allows you to add transactions, where you can specify how much you lended or borrowed. Users can create unlimited number of balances with the same friend. Each transaction must be confirmed by the other fellow before it gets added to the balance, but when confirmed - it cannot be modified/deleted, so act with great care! Each balance can be archived when its status is "Even". Transactions become archived together with the balance they correspond to and can be viewed by both users. Users can remove others form their friends list, but only when the overall status with them is "Even"!

## For future development - technical issues
- Add test suite!
- JS for Balances/Transaction forms.
- Make Transaction - make them not updated if the overall status not changed (when editing, the issuer and receiver is changed together with the :send_money, so the overall status remains, but the transaction IS updated in the DB.)

## For future development - features
- Searchbar
- Pagination with filters
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
- Create and migrate the database:
```
$ rake db:create
$ rake db:migrate
```