module ApplicationHelper

  def has_ad_access?(user, table, action=nil)
    user.membership = session[:user_memberships]
    if action
      ldap_groups = AccessLookup.where(table: table, :action => [action, 'all_actions']).pluck(:ldap_group)
    else
      ldap_groups = AccessLookup.where(table: table, :action => ['newedit_action', 'show_action', 'archive_action', 'all_actions']).pluck(:ldap_group)
    end
    (user.membership & ldap_groups).any?
  end

  def show_data_type_name(resource)
    if resource.data_type
      resource.data_type.display_name
    else
      "No data type has been selected"
    end
  end 

end
