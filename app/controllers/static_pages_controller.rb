class StaticPagesController < ApplicationController
  before_action :verify_duo_authentication, only: [:dashboard]

  def home
    @home_text = Infotext.find_by(location: "home")
    add_breadcrumb('', root_path)
  end

  def dashboard
    @dashboard_text = Infotext.find_by(location: "dashboard")
    add_breadcrumb(action_name.titleize)
  end

end

