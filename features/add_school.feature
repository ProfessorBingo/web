Feature: Add School
  In order to be able to find the correct professors
  Users need to be able to select one from their school
  We need to have schools that can be added by administrators
  
  Scenario: Go to the Schools Admin Console
    Given a user 'superadmin' exists
    And I am logged in as 'superadmin'
    And I am on 'Control Panel'
    And I see 'Schools'
    When I click 'Schools'
    Then I should see 'Add a new school'

  Scenario: Regular admin cannot create a school
    Given a user 'admin' exists
    And I am logged in as 'admin'
    And I am on 'Control Panel'
    When I click 'Schools'
    Then I should see 'Listing of schools:'
    And I should not see 'Add a new school'
    And I should not see 'Edit a school'

  Scenario: Add a new school with valid details
    Given a user 'superadmin' exists
    And I am logged in as 'superadmin'
    And my current url is '/controlpanel/schools/add/'
    And I see 'School Name'
    When I fill in the same 'name' as 'rose' into 'name'
    And I fill in the same 'short' as 'rose' into 'short'
    And I fill in the same 'emailext' as 'rose' into 'emailext'
    And I click the 'Add New School' button
    Then I should see 'School added successfully!'