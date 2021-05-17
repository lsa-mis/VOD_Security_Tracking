class StaticPagesController < ApplicationController
  def home
    @current_username = current_user.nil? ? current_admin_user.username : current_user.username
  end
end
