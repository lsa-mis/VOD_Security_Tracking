module Admin
  class UsersController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:user).permit(:email, :remember_created_at, :username)
    end
  end
end
