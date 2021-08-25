# == Schema Information
#
# Table name: departments
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  shortname        :string(255)
#  active_dir_group :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :department do
    name { Faker::String.random(length: 6..50) }
    shortname { Faker::String.random(length: 6..12) }
    active_dir_group { "" }
  end
end
