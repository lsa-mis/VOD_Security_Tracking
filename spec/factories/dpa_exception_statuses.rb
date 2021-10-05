# == Schema Information
#
# Table name: dpa_exception_statuses
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :dpa_exception_status do
    name { Faker::String.random(length: 6..12)}
    description { "" }
  end
end
