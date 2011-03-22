Feature: Logout
  In order to secure my account
  I need to be able to ensure others cannot gain unauthorized access
  Then I need to be able to log out
  
  Scenario: Successful User Logout
    Given A user 'student@school.edu' with password 'password' exists
    And I am logged in as 'student@school.edu' with password 'password'
    And I am on the home page
    When I click 'Logout'
    Then I should see 'Login'
    And I should see 'Register'
    And I should not see 'Logout'
    
  Scenario: Successful User Logout via JSON

    Given A user 'student@school.edu' with password 'password' exists
    And I log in using 'student@school.edu' with password 'password' on a mobile device
    When I log out using a mobile device
    Then the JSON authcode I recieve should be 'Success'