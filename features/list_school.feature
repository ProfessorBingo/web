Feature: List schools
  In order to administrate schools easier
  As an administrator
  I want to be able to see a list of schools from my control panel
  
  Scenario: Login and see a list of schools
    Given a user 'superadmin' exists
    And I am logged in as 'superadmin'
    And a school 'rose' exists
    And my current url is '/controlpanel'
    And I see 'Schools'
    When I click 'Schools'
    Then I should see 'Listing of schools'
    Then I should see a School 'rose'
  
  
  

  
