Feature: Save appeal

  Background: An appeal in progress
    Given I have an appeal in progress
    When I click on save and come back later
    Then I am taken to the save your appeal page

  Scenario: Password must be at least 8 characters
    When I enter a password that is not at least 10 characters
    Then I should see a password error message

  Scenario: Password can not be the same as the email address field
    And I enter the same password as the email address
    Then I should see a password error message

  Scenario: Invalid email
    When I enter an invalid email address
    And I enter a valid password
    Then I will see an invalid email error message

  Scenario: Successfully create an account
    When I enter a valid email address
    And I enter a valid password
    Then I should be taken to the saved confirmation page

  Scenario: I create an account then start again
    Given I enter a valid email address
    And I enter a valid password
    Then I should be taken to the saved confirmation page
    When I click 'start again'
    Then I am taken to the save your appeal page

  Scenario: Sign into an existing account and check bad login, forgot password
    When I click the 'Sign into an existing account' link
    Then I should see the sign in page

  Scenario: Timeout test - shouldn't trigger
    When I wait for 11 minutes
    And I enter a valid email address
    Then I will not see the invalid timeout error
