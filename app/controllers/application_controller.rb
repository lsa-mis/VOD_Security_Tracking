class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs

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

  def delete_file_attachment
    @delete_file = ActiveStorage::Attachment.find(params[:id])
    @delete_file.purge
    redirect_back(fallback_location: request.referer)
  end

  private

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def after_sign_in_path_for(resource)
      dashboard_path
    end  

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
