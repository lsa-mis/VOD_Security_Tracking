# == Schema Information
#
# Table name: data_types
#
#  id                           :bigint           not null, primary key
#  name                         :string(255)
#  description                  :string(255)
#  description_link             :string(255)
#  data_classification_level_id :bigint           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
FactoryBot.define do
  factory :data_type do
    name { Faker::String.random(length: 6..12) }
    description { Faker::String.random(length: 6..12) }
    description_link { "" }
    data_classification_level 
  end
end
