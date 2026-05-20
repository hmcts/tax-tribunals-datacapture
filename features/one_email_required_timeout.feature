Feature: One email required timeout

  Background: Go to closure user type page
    Given I navigate to closure user type page

  Scenario: Testing timeout for taxpayer - should trigger
    Given I submit that I am the tax payer making the application
    And I submit that I am an individual
    When I successfully submit taxpayers details
    And I wait for 11 minutes
    And I submit that I don't want a copy of the case details emailed to the taxpayer
    Then I will see the invalid session timeout error

  Scenario: Testing timeout for started with representative - should trigger
    Given I submit that I am not the tax payer making the application
    And I submit that the representative is a practising solicitor
    And I wait for 11 minutes
    And I submit that I am an individual
    Then I will see the invalid session timeout error
