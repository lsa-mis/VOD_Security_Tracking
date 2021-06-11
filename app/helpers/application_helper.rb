module ApplicationHelper

  def has_ad_access?(user, table, action=nil)
    user.membership = session[:user_memberships]
    # logger.debug "*********************************user.membership: #{user.membership}"
    # logger.debug "*********************************has_ad_access: #{action}"
    case action
    when  'newedit_action',
          'show_action',
          'archive_action',
          'audit_action'
      ldap_groups = AccessLookup.where(table: table, action: action).or(AccessLookup.where(table: table, action: 'all_actions')).pluck(:ldap_group)
    when nil
      ldap_groups = AccessLookup.where(table: table).pluck(:ldap_group)
    else
      ldap_groups = []
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

  def user_name_email(id)
    User.find(id).display_name
  end

end
