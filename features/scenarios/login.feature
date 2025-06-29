@desktop @login @eklipse
Feature: Log In eklipse web platform

@eklipse.login @success.login @freemember
Scenario: Verify free member can be successfully login at eklipse web platform
    Given User access eklipse
    And user direct to login page
    And User input email with data "email_free_member"
    And User input password with data "password_free_member"
    When User click log in button
    Then User verify successfully login to eklipse