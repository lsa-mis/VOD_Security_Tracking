module ApplicationHelper

  def has_ad_access?(user, table, action=nil)
    user.membership = session[:user_memberships]
    # logger.debug "*********************************user.membership: #{user.membership}"
    # logger.debug "*********************************has_ad_access: #{action}"
    if action
      ldap_groups = AccessLookup.where(table: table, :action => [action, 'all_actions']).pluck(:ldap_group)
    else
      ldap_groups = AccessLookup.where(table: table).pluck(:ldap_group)
    end
    (user.membership & ldap_groups).any?
  end
  
end
