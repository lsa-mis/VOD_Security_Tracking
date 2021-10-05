# == Schema Information
#
# Table name: storage_locations
#
#  id                 :bigint           not null, primary key
#  name               :string(255)
#  description        :string(255)
#  description_link   :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  device_is_required :boolean          default(FALSE)
#
FactoryBot.define do
  factory :storage_location do
    name { Faker::String.random(length: 6..12) }
    description { Faker::String.random(length: 6..12) }
    description_link { Faker::String.random(length: 6..12) }
    device_is_required { "false" }
  end
end
