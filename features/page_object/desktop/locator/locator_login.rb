module LocatorLoginPage
  CLICK_LOGIN ||= "(//a[@class='btn btn-login'])[2]"
  INPUT_EMAIL ||= "input[name='username']"
  INPUT_PASSWORD ||= "input[name='password']"
  BUTTON_LOGIN ||= "//button[contains(@class,'btn btn-primary')]"
  DIRECT_LOGIN_PAGE ||= "(//a[@class='btn btn-login'])[2]"
  HOME_LOGIN ||= "//span[normalize-space(text())='Home']"
  POP_UP_LOGIN_FAILED ||= "//div[normalize-space(text())='Your account or password is incorrect. Reset or change your password.']"
end
