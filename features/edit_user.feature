Feature: Edit user
  In order to maintain control of the system
  As an administrator
  I want to be able to edit users based on my permission level
  
  Scenario: Admin edits all values they can
    Given a user 'user' exists
    And a user 'admin' exists
    And 'user' is a 'standard'
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And my current url is '/controlpanel/user/edit/user*'
    When I fill in 'Bill' for 'first_name'
    And I click the 'Edit User' button
    Then I should see 'User successfully edited!'
    And 'first_name' should contain 'Bill'
    And the 'first_name' of user 'user' should be 'Bill'
  