# == Schema Information
#
# Table name: data_classification_levels
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :data_classification_level do
    name { Faker::String.random(length: 6..12) }
    description { Faker::String.random(length: 6..12) }
  end
end
