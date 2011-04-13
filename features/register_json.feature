Feature: Register via JSON
  In order to allow users to get setup quickly
  As an unregistered user
  I want to be able to register from my mobile device
  
  Scenario: Register correctly via JSON
    Given A user 'user' does not exist
    When I register as 'user' via JSON
    Then the JSON 'result' I receive should be 'Success'
    
  Scenario: Register incorrectly via JSON
    Given A user 'user' exists
    When I register as 'user' via JSON
    Then the JSON 'result' I receive should be 'FAIL'
  
  
  

  
