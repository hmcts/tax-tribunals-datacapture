Feature: Did you appeal the original decision (page both closure and appeal)

Background: Appeal decision question page
    Given I am on the challenge decision page

  Scenario: Select No
    When I select no
    Then I am taken to the must appeal decision status page

  Scenario: No option chosen
    When I continue with no option selected
    Then I see the problem error message
    And I am still on the challenge decision page

  Scenario: I have a review conclusion letter
    When I select yes
    Then I am taken to the challenge decision status page
    When I select I have a review conclusion letter
    Then I should be on the dispute type page

  Scenario: I have been waiting less than 45 days for a review to finish
    When I select yes
    Then I am taken to the challenge decision status page
    When I press continue with no response selected
    Then I will see the error response
    And I will still be on the decision status page
    When I select I have been waiting less than fourty five days
    Then I should be taken to the must wait for challenge decision page

  Scenario: I have been waiting for 45 days or more for a review to finish
    When I select yes
    Then I am taken to the challenge decision status page
    When I select I have been waiting for fourty five days or more for a review to finish
    Then I should be on the dispute type page

  Scenario: I was offered a review but didn't accept
    When I select yes
    Then I am taken to the challenge decision status page
    When I select I was offered a review
    Then I should be on the dispute type page

  Scenario: My appeal to HMRC was late
    When I select yes
    Then I am taken to the challenge decision status page
    When I select my appeal to HMRC was late
    Then I am taken to the are you in time page

  Scenario: I am appealing direct to the tribunal before receiving a response from HMRC
    When I select yes
    Then I am taken to the challenge decision status page
    When I select I am appealing direct to the tribunal before receiving a response from HMRC
    Then I should be on the dispute type page

  Scenario: I press 'Help with challenging a decision'
    When I press 'Help with challenging a decision'
    Then I will see the original notice text
    And I see a link 'challenge a tax decision with HM Revenue and Customs' with the correct URL

  Scenario: UK border force
    When I press 'Help with challenging a decision'
    Then I will see the original notice text
    And I see a link 'options when UK border force seizes your things' with the correct URL

  Scenario: NCA
    When I press 'Help with challenging a decision'
    Then I will see the original notice text
    And I see a link 'challenge a national crime agency' with the correct URL

  Scenario: Timeout test - shouldn't trigger
    When I wait for 11 minutes
    And I click continue
    Then The error should appear
    And I will not see the invalid timeout error