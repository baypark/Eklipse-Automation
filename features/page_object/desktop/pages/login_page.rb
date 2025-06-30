require_relative '../../base/base_page'
require_relative '../locator/locator_login'

class LoginPage < SitePrism::Page
  include BasePage
  include LocatorLoginPage

  config_email = get_config_data('email_free_member')
  config_pass = get_config_data('password_free_member')
  config_url = get_config_data('url')
  set_url(config_url)

#object
  element :eklipse_login_input_email, INPUT_EMAIL
  element :eklipse_login_input_password, INPUT_PASSWORD
  element :eklipse_login_button, :xpath, BUTTON_LOGIN
  element :eklipse_direct_login_page, :xpath, DIRECT_LOGIN_PAGE
  element :eklipse_login_success, :xpath, HOME_LOGIN
  element :eklipse_login_failed, :xpath, POP_UP_LOGIN_FAILED

#methods
  def direct_login
    eklipse_direct_login_page.click
    wait_in_sec(2)
  end

  def input_email(email)
    eklipse_login_input_email.set(email)
  end

  def input_password(pass)
    eklipse_login_input_password.set(pass)
  end

  def click_login_button
    eklipse_login_button.click
    sleep 3
  end

  def validate_login_page
    eklipse_login_success.should be_visible
  end

def invalid_password(invalidPass)
  eklipse_login_input_password.set (invalidPass)
end

  def validate_failed_login
    wait_in_sec(2)
    eklipse_login_failed.should be_visible
  end
end
