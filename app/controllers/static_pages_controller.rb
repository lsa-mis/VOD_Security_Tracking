class StaticPagesController < ApplicationController
  add_breadcrumb "home", :root_path

  def home
  end

  def dashboard
    add_breadcrumb "dashboard", dashboard_path
  end
end