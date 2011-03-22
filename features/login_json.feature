Feature: Mobile Login
  In order to secure my account
  I need to be able to ensure others cannot gain unauthorized access
  Then I need to be able to log out
  And I need to be able to do so from my phone or other mobile internet device

  Scenario: Login from a mobile device correctly
    Given A user 'student@school.edu' with password 'password' exists
    And I log in using 'student@school.edu' with password 'password' on a mobile device
    Then the JSON authcode I receive should be 'TimeBasedAuthCode'
    And the code should be associated with 'student@school.edu'

  Scenario: Login from a mobile device incorrectly
    Given A user 'student@school.edu' with password 'password' exists
    And I log in using 'student@school.edu' with password 'wrong' on a mobile device
    Then the JSON authcode I receive should be 'FAIL'