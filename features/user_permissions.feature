Feature: Create administrative and moderator users
  In order to maintain control over the system
  There must be a special class of users to watch over the others
  These users must be able to be created manually and automatically

  Scenario: User is regular when there are more than 0 users in the system
    Given '0' users exist
    And A user 'admin' exists
    And more than '0' users exist
    When I create a user 'user'
    Then 'user' should not be an 'admin'
    And 'admin' should be an 'admin'
    
  Scenario: Make sure moderators can exist
    Given '0' users exist
    And A user 'admin' exists
    And more than '0' users exist
    When I create a user 'mod'
    Then 'mod' should not be an 'admin'
    And 'mod' should be a 'mod'
    And 'admin' should be an 'admin'
    
  Scenario: Admins can get to control panel from link
    Given A user 'admin' exists
    And I am logged in as 'admin'
    And I am on the home page
    When I click 'Control Panel'
    Then I should see 'Administrator Control Panel'
    
  Scenario: Admins can get to control panel from url
    Given A user 'admin' exists
    And I am logged in as 'admin'
    And I am on the home page
    When I go to '/controlpanel'
    Then I should see 'Administrator Control Panel'
    
  Scenario: Non-Admins cannot get to control panel
    Given A user 'user' exists
    And I am logged in as 'user'
    And I am on the home page
    And I should not see 'Control Panel'
    When I go to '/controlpanel'
    Then I should not see 'Administrator Control Panel'
    And I should see Welcome 'user'
    
  Scenario: Admin has a desire to make another user an Admin
    Given A user 'admin' exists
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And I am on 'Control Panel'
    When I click 'Add an Admin'
    Then I should see 'Make another user an Administrator'
    And I should see 'Make user an Admin'
    And I should not see 'Make user a Super Admin'

  Scenario: SuperAdmin has a desire to make another user an Admin
    Given A user 'superadmin' exists
    And 'superadmin' is an 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Control Panel'
    When I click 'Add an Admin'
    Then I should see 'Make another user an Administrator'
    And I should see 'Make user an Admin'
    And I should see 'Make user a Super Admin'
      
  Scenario: Admin makes another user an admin
    Given A user 'admin' exists
    And A user 'user' exists
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And I am on 'Add an Admin'
    And I should not see 'Make user a Super Admin'
    When I fill in the same 'email' as 'user' into 'user'
    And click 'Make user an Admin'
    Then 'user' should be an 'admin'
    
  Scenario: SuperAdmin makes another user an admin
    Given A user 'superadmin' exists
    And A user 'user' exists
    And 'superadmin' is an 'admin'
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in the same 'email' as 'user' into 'user'
    And click 'Make user an Admin'
    Then 'user' should be a 'admin'
    
  Scenario: SuperAdmin makes another user a superadmin
    Given A user 'superadmin' exists
    And A user 'user' exists
    And 'superadmin' is an 'admin'
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in the same 'email' as 'user' into 'user'
    And click 'Make user a Super Admin'
    Then 'user' should be a 'superadmin'