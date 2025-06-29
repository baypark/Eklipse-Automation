require_relative '../../base/base_page'
require_relative '../locator/locator_pos_header'

class PosHeader < SitePrism::Page
  include BasePage
  include PosHeaderLocator

  element :icon_avatar, :xpath, XPATH_ICON_AVATAR

  def is_already_logged_in
    icon_avatar.should be_visible
  end
end
