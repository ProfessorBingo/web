Feature: Mobile Logout
  In order to secure my account
  I need to be able to ensure others cannot gain unauthorized access
  Then I need to be able to log out
  And I need to be able to do so from my phone or other mobile internet device
  
  Scenario: Successful User Logout via JSON
    Given A user 'user' exists
    And I log in as 'user' via JSON
    When I log out as 'user' via JSON
    Then the JSON authcode I receive should be 'Success'