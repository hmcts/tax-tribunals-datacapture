@smoke
Feature: Start to end
  # Scenario: Screenshots
  #   Given I take a screenshot of appeal
  #   And I take a screenshot of closure

  Scenario: Completion of a valid closure application
    Given I complete a valid closure application
    Then I should be told that the application has been successfully submitted
    And I can access the finish survey

  Scenario: Completion of a valid appeal application
    Given I complete a valid appeal application
    Then I should be told that the application has been successfully submitted
    And I can access the finish survey

  Scenario: Timeout test - shouldn't trigger
    Given I complete a valid appeal application
    Then I should be told that the application has been successfully submitted
    And I wait for 11 minutes
    And I can access the finish survey
