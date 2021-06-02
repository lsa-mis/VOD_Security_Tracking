# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  table      :string(255)
#  action     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AccessLookup < ApplicationRecord

    enum action: {
        new_action: "new-edit_action",
        show_action: "show_action",
        archive_action: "archive_action",
        all_actions: "all_actions"
    }
    enum table: {
        dpa_exceptions: 'dpa_exceptions',
        it_security_incidents: 'it_security_incidents',
        legacy_os_records: 'legacy_os_records',
        sensitive_data_systems: 'sensitive_data_systems'
    }

    validates :ldap_group, presence: true
    validates :table, presence: true
    validates :action, presence: true
    
end
