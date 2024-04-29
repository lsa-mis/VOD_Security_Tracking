class CustomFailureApp < Devise::FailureApp
  def respond
    if ldap_not_authenticated?
      redirect_to ldap_error_path
    elsif request.format == :turbo_stream
      redirect
    else
      super
    end
  end

  protected

  def redirect
    message = i18n_message(:invalid)
    flash[:alert] = message
    redirect_to new_user_session_path
  end

  private

  def ldap_not_authenticated?
    # Check the environment or specific error codes/messages to identify the LDAP issue
    request.env['warden'].message == :ldap_not_authenticated
  end
end