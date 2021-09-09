# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vod_table  :integer          default(NULL), not null
#  vod_action :integer          default(NULL), not null
#
class AccessLookup < ApplicationRecord

  enum vod_action: {
    show: 0,
    newedit: 1,
    archive: 2,
    audit: 3,
    all: 4
  }, _prefix: true

  enum vod_table: {
    not_selected: 0,
    dpa_exceptions: 1,
    it_security_incidents: 2,
    legacy_os_records: 3,
    sensitive_data_systems: 4,
    devices: 5,
    admin_interface: 6
  }, _prefix: true

  validates :ldap_group, presence: true
  validate :select_vod_table
  validates :vod_action, presence: true

  def select_vod_table
    errors.add(:vod_table, "select a table") if vod_table == "not_selected"
  end
end
