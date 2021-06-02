class StaticPagesController < ApplicationController
  # skip_before_action :set_membership
  
  def home
    add_breadcrumb('', root_path)
  end

  def dashboard
    @current_username = current_user.nil? ? current_admin_user.username : current_user.username
    add_breadcrumb(action_name.titleize)
  end

end

