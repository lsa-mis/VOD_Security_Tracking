# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  table      :integer          default("no_table"), not null
#  action     :integer          default("no_action"), not null
#
class AccessLookup < ApplicationRecord

  enum action: [
    :no_action,
    :newedit_action,
    :show_action,
    :archive_action,
    :audit_action,
    :all_actions
  ]
  enum table: [
    :no_table,
    :dpa_exceptions,
    :it_security_incidents,
    :legacy_os_records,
    :sensitive_data_systems
  ]

  validates :ldap_group, presence: true
  validates :table, presence: true
  validates :action, presence: true

end
