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

  Scenario: Make sure superadmins can exist
    Given '0' users exist
    And A user 'admin' exists
    And more than '0' users exist
    When I create a user 'superadmin'
    Then 'superadmin' should be a 'superadmin'
    And 'superadmin' should be an 'admin'
    And 'superadmin' should be a 'supermod'
    And 'superadmin' should be a 'mod'
    And 'admin' should be an 'admin'

  Scenario: Make sure admins can exist
    Given '0' users exist
    And A user 'user' exists
    And more than '0' users exist
    When I create a user 'admin'
    Then 'admin' should not be a 'superadmin'
    And 'admin' should be an 'admin'
    And 'admin' should be a 'supermod'
    And 'admin' should be a 'mod'
    And 'user' should not be a 'mod'

  Scenario: Make sure super moderators can exist
    Given '0' users exist
    And A user 'admin' exists
    And more than '0' users exist
    When I create a user 'supermod'
    Then 'supermod' should not be a 'superadmin'
    And 'supermod' should not be an 'admin'
    And 'supermod' should be a 'supermod'
    And 'supermod' should be a 'mod'
    And 'admin' should be an 'admin'

  Scenario: Make sure moderators can exist
    Given '0' users exist
    And A user 'admin' exists
    And more than '0' users exist
    When I create a user 'mod'
    Then 'mod' should not be a 'superadmin'
    And 'mod' should not be an 'admin'
    And 'mod' should not be a 'supermod'
    And 'mod' should be a 'mod'
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
    And I should not see 'Super Admins have root access'

  Scenario: SuperAdmin has a desire to make another user an Admin
    Given A user 'superadmin' exists
    And 'superadmin' is an 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Control Panel'
    When I click 'Add an Admin'
    Then I should see 'Make another user an Administrator'
    And I should see 'Super Admins have root access'
      
  Scenario: Admin makes another user an admin
    Given A user 'admin' exists
    And A user 'user' exists
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And I am on 'Add an Admin'
    And I should not see 'Super Admins have root access'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'admin'
    And I click the 'Submit' button
    Then 'user' should be an 'admin'
    
  Scenario: Admin makes another user a supermod
    Given A user 'admin' exists
    And A user 'user' exists
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And I am on 'Add an Admin'
    And I should not see 'Super Admins have root access'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'supermod'
    And I click the 'Submit' button
    Then 'user' should be an 'supermod'
    
  Scenario: Admin makes another user a mod
    Given A user 'admin' exists
    And A user 'user' exists
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And I am on 'Add an Admin'
    And I should not see 'Super Admins have root access'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'mod'
    And I click the 'Submit' button
    Then 'user' should be an 'mod'
    
  Scenario: Admin revokes permissions
    Given A user 'admin' exists
    And A user 'user' exists
    And 'admin' is an 'admin'
    And I am logged in as 'admin'
    And I am on 'Add an Admin'
    And I should not see 'Super Admins have root access'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'standard'
    And I click the 'Submit' button
    Then 'user' should not be an 'superadmin'
    And 'user' should not be an 'admin'
    And 'user' should not be an 'supermod'
    And 'user' should not be an 'mod'
    
  Scenario: SuperAdmin makes another user an admin
    Given A user 'superadmin' exists
    And A user 'user' exists
    And 'superadmin' is an 'admin'
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'admin'
    And I click the 'Submit' button
    Then 'user' should be a 'admin'
    
  Scenario: SuperAdmin makes another user a superadmin
    Given A user 'superadmin' exists
    And A user 'user' exists
    And 'superadmin' is an 'admin'
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'superadmin'
    And I click the 'Submit' button
    Then 'user' should be a 'superadmin'
    
  Scenario: SuperAdmin demotes other SuperAdmin
    Given A user 'superadmin' exists
    And A user 'user' exists
    And I make 'user' a 'superadmin'
    And 'user' is a 'superadmin'
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in the same 'email' as 'user' into 'email'
    And I choose 'standard'
    And I click the 'Submit' button
    Then 'user' should not be an 'superadmin'
    And 'user' should not be an 'admin'
    And 'user' should not be an 'supermod'
    And 'user' should not be an 'mod'
    
  Scenario: SuperAdmin tries to demote self
    Given A user 'superadmin' exists
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in the same 'email' as 'superadmin' into 'email'
    And I choose 'standard'
    And I click the 'Submit' button
    Then 'superadmin' should be an 'superadmin'
    And I should see 'Error: You cannot demote yourself'
    
  Scenario: Admin tries to change permissions of a user that does not exist
    Given A user 'superadmin' exists
    And 'superadmin' is a 'superadmin'
    And I am logged in as 'superadmin'
    And I am on 'Add an Admin'
    When I fill in 'blah' for 'email'
    And I choose 'admin'
    And I click the 'Submit' button
    And I should see 'Error: You must enter a valid user'
    And 'email' should contain 'blah'