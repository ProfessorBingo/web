Feature: Login
  In order to play bingo
  I need to be able to choose a professor
  And In order to choose a professor, I must be identified as a member of that school
  And In order to be identified as a member of a school, I need to login.
  
  Scenario: Get to the Login Page
    Given A user 'user' exists
    And I am on the home page
    When I click 'Login'
    Then I should see 'Login to start playing Professor Bingo'

  Scenario: Login with Valid Credentials
    Given A user 'user' exists
    And I am on the 'login' page
    And I fill in the same 'email' as 'user' into 'email'
    And I fill in the same 'password' as 'user' into 'password'
    When I click the 'Login' button
    Then I should see Welcome 'user'

  Scenario: Login with Invalid Username
    Given A user 'user' exists
    And I am on the 'login' page
    And I fill in 'wrong' for 'email'
    And I fill in the same 'password' as 'user' into 'password'
    When I click the 'Login' button
    Then I should see 'Invalid username or password'

  Scenario: Login with Invalid Password
    Given A user 'user' exists
    And I am on the 'login' page
    And I fill in the same 'email' as 'user' into 'email'
    And I fill in 'wrong' for 'password'
    When I click the 'Login' button
    Then I should see 'Invalid username or password'

  Scenario: Login with Invalid Username and Password
    Given A user 'user' exists
    And I am on the 'login' page
    And I fill in 'wrong' for 'email'
    And I fill in 'wrong' for 'password'
    When I click the 'Login' button
    Then I should see 'Invalid username or password'
