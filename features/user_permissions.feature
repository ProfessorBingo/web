Feature: Create administrative and moderator users
  In order to maintain control over the system
  There must be a special class of users to watch over the others
  These users must be able to be created manually and automatically
  
  Scenario: User becomes an admin when there are no users in the system
    Given '0' users exist
    When I create a user 'user'
    Then 'user' should be an 'admin'