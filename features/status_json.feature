Feature: Allow Devices to determine if their authcode is valid
  In order to have users that enjoy using our app
  They need to be able to save their login state on the mobile device
  To do this, we need to make sure a device can ask the server if it is valid
  
  Scenario: Successful Status Query
    Given A user 'user' exists
    And I log in as 'user' via JSON
    When I ask for status as 'user' via JSON
    Then the JSON 'result' I receive should be 'Success'

  Scenario: Status Query Failure
    Given A user 'user' exists
    And I log in as 'user' via JSON
    And I log out as 'user' via JSON
    When I ask for status as 'user' via JSON
    Then the JSON 'result' I receive should be 'FAIL'