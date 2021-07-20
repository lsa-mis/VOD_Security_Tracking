module ActiveAdmin
  class PagePolicy < AdminPolicy
    def show?
      # Rails.logger.debug "************************** membership #{$membership}"
      # Rails.logger.debug "************************** @admins_groups #{@admins_groups}"
      case record.name
      when 'Dashboard'
        # true
        ($membership & @admins_groups).any?
      else
        false
      end
    end
  end
end