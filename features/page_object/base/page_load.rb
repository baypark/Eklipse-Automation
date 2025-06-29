class Page
  def initialize(tags)
    @tags = tags
  end

  def load(desktop = nil)
    desktop if @tags.include?('@desktop')
  end

  def eklipse_login_page
    load(LoginPage.new)
  end
end