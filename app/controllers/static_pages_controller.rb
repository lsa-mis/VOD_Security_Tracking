class StaticPagesController < ApplicationController
  before_action :verify_duo_authentication, only: [:dashboard]

  def home
    add_breadcrumb('', root_path)
    @home_page_text = ApplicationSetting.find_by(page: "Home").index_description
  end

  def dashboard
    @current_username = current_user.nil? ? current_admin_user.username : current_user.username
    @dashboard_text = ApplicationSetting.find_by(page: "Dashboard").index_description
    add_breadcrumb(action_name.titleize)
  end

end

