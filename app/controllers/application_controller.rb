class ApplicationController < ActionController::Base

  before_action :set_breadcrumbs

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

 def add_breadcrumb(label, path = nil)
  @breadcrumbs << {
    label: label,
    path: path
  }
 end

 def set_breadcrumbs
  @breadcrumbs = []
 end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
