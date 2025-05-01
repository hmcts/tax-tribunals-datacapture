Given("I complete a valid closure application") do
  complete_valid_closure_application
end

Given("I complete a valid appeal application") do
  complete_valid_appeal_application
end

Then("I should be told that the application has been successfully submitted") do
  expect(confirmation_page.content).to have_case_submitted_header
end

When("I click Finish") do
  max_attempts = 5
  attempts = 0
  success = false

  until success || attempts >= max_attempts
    attempts += 1
    begin
      puts "Attempt #{attempts} to click Finish"
      confirmation_page.finish

      timestamp = Time.now.to_i
      save_screenshot("tmp/finish_debug_#{timestamp}.png")
      File.write("tmp/finish_debug_#{timestamp}.html", page.html)
      puts "Finish button clicked and page captured successfully"

      success = true
    rescue => e
      puts "Error on attempt #{attempts} while clicking Finish: #{e.message}"
      sleep 2 unless attempts >= max_attempts
    end
  end

  raise "Failed to click Finish after #{max_attempts} attempts" unless success
end

Then("I should be on the Smart Survey link") do
  expect(page).to have_text "Thank you for taking your time to tell us what you think about the Tax Tribunal online service."
end

# rubocop:disable Lint/AmbiguousRegexpLiteral
Given /^I take a screenshot of (.*)$/ do |journey|
  screenshot_closure_application(journey)
end
# rubocop:enable Lint/AmbiguousRegexpLiteral
