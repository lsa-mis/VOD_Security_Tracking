module ActiveAdmin
  class PagePolicy < AdminPolicy
    def show?
      case record.name
      when 'Dashboard'
      (user.membership & @admins_groups).any?
      else
        false
      end
    end
  end
end
