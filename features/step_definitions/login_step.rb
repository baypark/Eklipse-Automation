Given("User access eklipse") do
    @page.eklipse_login_page.load
end

When("user direct to login page") do
    @page.eklipse_login_page.direct_login
end
  
When("User input email with data {string}") do |email|
    wait_in_sec(1)
    email = get_config_data('email_free_member')
    @page.eklipse_login_page.input_email(email)
end
  
When("User input password with data {string}") do |password|
    wait_in_sec(1)
    password = get_config_data('password_free_member')
    @page.eklipse_login_page.input_password(password)
end
  
When("User click log in button") do
    @page.eklipse_login_page.click_login_button
end

Then("User verify successfully login to eklipse") do
    @page.eklipse_login_page.validate_login_page
end