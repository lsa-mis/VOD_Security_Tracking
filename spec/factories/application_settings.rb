# == Schema Information
#
# Table name: application_settings
#
#  id         :bigint           not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :application_setting do
    title { "MyString" }
  end
end
