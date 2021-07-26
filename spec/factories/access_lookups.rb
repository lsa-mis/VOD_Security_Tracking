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
FactoryBot.define do
  factory :access_lookup do
    ldap_group { "MyString" }
    table { "MyString" }
    action { "MyString" }
  end
end
