require_relative '../page_object/base/page_load'
require_relative '../helper/other/report_helper'
# require_relative '../helper/data'
# require_relative '../helper/data'
# require_relative '../helper/data'


# ------ Before ------ #
Before do |scenario|
  # Config browser
  @tags = scenario.source_tag_names
  @page = Page.new(@tags)
  load_browser(@tags)
  # Maximize if not in mobile or headless mode
  # unless ENV['MWEB'] == 'true' || ENV['HEADLESS'] == 'true'
  if ENV['MAXIMIZE'].eql?('yes')
    Capybara.current_session.driver.browser.manage.window.maximize
  end
  # set_browser_resolution(@tags)
end

# Before('@xms') do
#   $xms_token = api_get_user_token_xms
# end

# Before do |scenario|
#   # initialize data
#   $account_data = AccountData.new
#   $checkout_data = CheckoutData.new
#   $product_data = ProductData.new
# end

# ------ After ------ #
# After do |scenario|
#   scenario_count(scenario)
#   take_screenshot(scenario) if scenario.failed?
#   Capybara.current_session.driver.quit
# end

After('@shopping.bag or @checkout') do |scenario|
  data = $product_data.get_list_product_data
  ids = []
  data.each do |product|
    product[:variants].each do |variant|
      ids << variant.id
    end
  end
  api_remove_cart_by_id(ids)
end

After('@account.delete') do
  email = $account_data.get_current_email_data
  password = $account_data.get_current_password_data
  user_token = api_get_user_token(email, password)
  api_delete_user(user_token)
end

After('@account.sso.delete') do
  @cookies = page.driver.browser.manage.all_cookies
  @cookies.each do |cookie|
    puts "Cookie name: #{cookie[:name]}, Cookie value: #{cookie[:value]}"
    if ENV["TARGET"].eql?('dev') && cookie[:name] == 'dev_pos_jt_token'
      @dev_pos_jt_token = cookie[:value]
    elsif ENV["TARGET"].eql?('stg') && cookie[:name] == 'stg_pos_jt_token'
      @stg_pos_jt_token = cookie[:value]
    end
  end

  if ENV["TARGET"].eql?('dev')
    user_token = @dev_pos_jt_token
    if user_token
      api_delete_user(user_token)
    else
      puts "dev_pos_jt_token cookie not found."
    end
  elsif ENV["TARGET"].eql?('stg')
    user_token = @stg_pos_jt_token
    if user_token
      api_delete_user(user_token)
    else
      puts "stg_pos_jt_token cookie not found."
    end
  else
    puts "Unknown environment target."
  end
end

AfterConfiguration do |config|
  $tags_run = config.tag_expressions
end


