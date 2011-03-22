Feature: Mobile Logout
  In order to secure my account
  I need to be able to ensure others cannot gain unauthorized access
  Then I need to be able to log out
  And I need to be able to do so from my phone or other mobile internet device
  
  Scenario: Successful User Logout via JSON
    Given A user 'student@school.edu' with password 'password' exists
    And I log in using 'student@school.edu' with password 'password' on a mobile device
    When I log out using a mobile device
    Then the JSON authcode I receive should be 'Success'