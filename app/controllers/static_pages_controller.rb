class StaticPagesController < ApplicationController
  before_action :verify_duo_authentication, only: [:dashboard]

  def home
    @home_text = ApplicationSetting.find_by(title: "home")

    add_breadcrumb('', root_path)
  end

  def dashboard
    @current_username = current_user.nil? ? current_admin_user.username : current_user.username
    @dashboard_text = ApplicationSetting.find_by(title: "dashboard")
    add_breadcrumb(action_name.titleize)
  end

end

