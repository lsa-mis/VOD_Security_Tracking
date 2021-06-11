# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  table      :integer          default("no_table"), not null
#  action     :integer          default("show_action"), not null
#
FactoryBot.define do
  factory :access_lookup do
    ldap_group { "MyString" }
    table { "MyString" }
    action { "MyString" }
  end
end
