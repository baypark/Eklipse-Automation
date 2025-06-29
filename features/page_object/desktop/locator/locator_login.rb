module LocatorLoginPage
  CLICK_LOGIN ||= "(//a[@class='btn btn-login'])[2]"
  INPUT_EMAIL ||= "input[name='username']"
  INPUT_PASSWORD ||= "input[name='password']"
  BUTTON_LOGIN ||= "//button[@type='submit']"
  DIRECT_LOGIN_PAGE ||= "(//a[@class='btn btn-login'])[2]"
  HOME_LOGIN ||= "//span[normalize-space(text())='Home']"
end
