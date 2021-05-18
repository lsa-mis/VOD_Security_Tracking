class ApplicationController < ActionController::Base
before_action :set_breadcrumbs
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

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


  def after_sign_in_path_for(resource)
    dashboard_path
  end  

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
