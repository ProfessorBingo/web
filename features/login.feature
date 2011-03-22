Feature: Login
  In order to play bingo
  I need to be able to choose a professor
  And In order to choose a professor, I must be identified as a member of that school
  And In order to be identified as a member of a school, I need to login.
  
  Scenario: Get to the Login Page
    Given A user 'student@school.edu' with password 'password' exists
    And I am on the home page
    When I click 'Login'
    Then I should see 'Login to start playing Professor Bingo'

  Scenario: Login with Valid Credentials
    Given A user 'student@school.edu' with password 'password' exists
    And I am on the 'login' page
    And I fill in 'student@school.edu' for 'email'
    And I fill in 'password' for 'password'
    When I click the 'Login' button
    Then I should see 'Welcome student@school.edu'

  Scenario: Login with Invalid Username
    Given A user 'student@school.edu' with password 'password' exists
    And I am on the 'login' page
    And I fill in 'wrong' for 'email'
    And I fill in 'password' for 'password'
    When I click the 'Login' button
    Then I should see 'Invalid username or password'

  Scenario: Login with Invalid Password
    Given A user 'student@school.edu' with password 'password' exists
    And I am on the 'login' page
    And I fill in 'student@school.edu' for 'email'
    And I fill in 'wrong' for 'password'
    When I click the 'Login' button
    Then I should see 'Invalid username or password'

  Scenario: Login with Invalid Username and Password
    Given A user 'student@school.edu' with password 'password' exists
    And I am on the 'login' page
    And I fill in 'wrong' for 'email'
    And I fill in 'wrong' for 'password'
    When I click the 'Login' button
    Then I should see 'Invalid username or password'
    
  Scenario: Login from a mobile device correctly
    Given A user 'student@school.edu' with password 'password' exists
    And I log in using 'student@school.edu' with password 'password' on a mobile device
    Then the JSON authcode I recieve should be 'TimeBasedAuthCode'
    
  Scenario: Login from a mobile device incorrectly
    Given A user 'student@school.edu' with password 'password' exists
    And I log in using 'student@school.edu' with password 'wrong' on a mobile device
    Then the JSON authcode I recieve should be 'FAIL'
    