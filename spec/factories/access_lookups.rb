# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vod_table  :integer          default("not_selected"), not null
#  vod_action :integer          default("show"), not null
#
FactoryBot.define do
  factory :access_lookup do
    ldap_group { "lsa-vod-devs" }
    vod_table { "dpa_exceptions" }
    vod_action { "all" }
  end
end
