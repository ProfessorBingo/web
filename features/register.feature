Feature: Registration
  In order to play bingo
  I need to be able to choose a professor
  And In order to choose a professor, I must be identified as a member of that school
  And In order to be identified as a member of a school, I need to register as an authenticated user.
  
  Scenario: Get to registration page
    Given I am on the home page
    And I see 'Professor Bingo!'
    When I click 'Register'
    Then I should see 'Register for Professor Bingo'
    
  Scenario: Enter Information incorrectly on registration page
    Given I am on the 'register' page
    And I see 'Register for Professor Bingo'
    And I fill in 'student@college.edu' for 'email'
    And I fill in 'password' for 'password'
    And I fill in 'Eric' for 'first_name'
    When I click the 'Register' button
    Then I should see 'Registration Failed'
    Then 'email' should contain 'student@college.edu'
    Then 'password' should contain 'password'
    
  Scenario: Enter Information correctly on registration page
    Given I am on the 'register' page
    And I see 'Register for Professor Bingo'
    And I fill in 'Eric' for 'first_name'
    And I fill in 'Stokes' for 'last_name'
    And I fill in 'password' for 'password'
    And I fill in 'student@college.edu' for 'email'
    When I click the 'Register' button
    Then I should see 'Registration Successful'
    Then the user 'student@college.edu' should exist
    
  Scenario: Email is already taken
    Given I am on the 'register' page
    And I see 'Register for Professor Bingo'
    And I fill in 'Eric' for 'first_name'
    And I fill in 'Stokes' for 'last_name'
    And I fill in 'password' for 'password'
    And I fill in 'student@college.edu' for 'email'
    When I click the 'Register' button
    Then I should see 'Registration Failed'
    And I should see 'That email address has already been used'