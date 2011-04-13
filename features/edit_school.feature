Feature: Edit school
  In order to make sure values don't get entered incorrectly
  As an administrator
  I want to be able to edit schools by changing name, short and email extension
  
  Scenario: Edit a school by searching for it
    Given a user 'superadmin' exists
    And I am logged in as 'superadmin'
    And a school 'rose' exists
    And my current url is '/controlpanel/school'
    And I see 'Edit a school'
    When I click 'Edit a school'
    Then I should see 'Find a school'
  
  Scenario: Edit a school by clicking it in the list of schools
    Given a user 'superadmin' exists
    And I am logged in as 'superadmin'
    And a school 'rose' exists
    And my current url is '/controlpanel/school'
    And I see 'Edit a school'
    When I click school name 'rose'
    Then I should see a School 'rose'
  
  