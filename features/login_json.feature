Feature: Mobile Login
  In order to secure my account
  I need to be able to ensure others cannot gain unauthorized access
  Then I need to be able to log out
  And I need to be able to do so from my phone or other mobile internet device

  Scenario: Login from a mobile device correctly
    Given A user 'user' exists
    And I log in as 'user' via JSON
    Then the JSON 'result' I receive should be 'Success'
    And the 'authcode' should be associated with 'user'

  Scenario: Login from a mobile device incorrectly
    Given A user 'user' exists
    And I log in as 'user' via JSON incorrectly
    Then the JSON 'result' I receive should be 'FAIL'