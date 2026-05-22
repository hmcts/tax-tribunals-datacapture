Feature: Appeal case type page

  Background: Appeal case type page
    Given I am on the appeal case type page

  Scenario: Error message
    When I click on continue without selecting an option
    Then I should be on the appeal case type page
    And I should see appeal case type error message

  Scenario: Successful step (Income tax)
    When I click on continue after selecting Income Tax option
    Then I am on the Income Tax case type details page
    And I select nothing then english only
    Then I should be on the appeal challenge decision page

  Scenario: Successful step (Student loans)
    When I click on continue after selecting Student loans option
    Then I am on the Student loans case type details page
    And I select nothing then english only
    Then I should be on the appeal challenge decision page

  Scenario: Detail is not provided to None of the above option
    When I click on continue after selecting Other option
    Then I should see appeal case type presence error message

  Scenario: Detail is provided to None of the above option
    When I click on continue after selecting Other option with text
    And I select nothing then english only
    Then I should be on the lateness page

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I click continue
    Then I will see the invalid session timeout error

