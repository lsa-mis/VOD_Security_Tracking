class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  def after_sign_in_path_for(resource)
    home_path
  end  
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
