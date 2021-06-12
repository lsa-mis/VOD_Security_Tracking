class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs
 # before_action :verify_duo_authentication 

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  def add_breadcrumb(label, path = nil)
    @breadcrumbs << {
      label: label,
      path: path
    }
  end

  def verify_duo_authentication
    if !session[:duo_auth]
      redirect_to duo_path
    end
  end

  private

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def after_sign_in_path_for(resource)
      duo_path
      # dashboard_path
    end  

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
