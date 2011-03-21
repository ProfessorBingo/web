Feature: Registration
  In order to play bingo
  I need to be able to choose a professor
  And In order to choose a professor, I must be identified as a member of that school
  
  Scenario: Get to registration page
    Given I am on the home page
    When I click 'Register'
    Then I should see 'Register for Professor Bingo'