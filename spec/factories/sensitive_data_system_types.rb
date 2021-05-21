# == Schema Information
#
# Table name: sensitive_data_system_types
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :sensitive_data_system_type do
    name { "MyString" }
    description { "MyString" }
  end
end
