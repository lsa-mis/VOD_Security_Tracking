module ActiveAdmin
  class PagePolicy < AdminPolicy
    def show?
      # Rails.logger.debug "************************** membership #{$membership}"
      # Rails.logger.debug "************************** @admins_groups #{@admins_groups}"
      # fail
      # ($membership & @admins_groups).any?
      true
    end
  end
end