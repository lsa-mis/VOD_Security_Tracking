# == Schema Information
#
# Table name: devices
#
#  id           :bigint           not null, primary key
#  serial       :string(255)
#  hostname     :string(255)
#  mac          :string(255)
#  building     :string(255)
#  room         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner        :string(255)
#  department   :string(255)
#  manufacturer :string(255)
#  model        :string(255)
#
FactoryBot.define do
  factory :device do
    serial { Faker::String.random(length: 6..12) }
    hostname { Faker::String.random(length: 6..12) }
  end
end
