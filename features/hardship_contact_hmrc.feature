Feature: Hardship contact HMRC page

  Background: Contact HMRC page
    Given I create an indirect tax application where HMRC claim I owe money
    And I am on the contact HMRC page

  Scenario: Redirect to HMRC page buttom
    Given I have the button to contact HMRC
    And the button is link to a form

  Scenario: Return to hardship options
    Then I have a back button

  Scenario: Verify Welsh language link
    When I click on the 'Cymraeg' link
    Then I will see the website open in that language

  Scenario: Timeout test - should trigger
    When I wait for 11 minutes
    And I select the button to contact HMRC
    Then I will see the invalid session timeout error
