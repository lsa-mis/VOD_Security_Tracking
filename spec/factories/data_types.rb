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
    name { "MyString" }
    description { "MyString" }
    description_link { "MyString" }
    data_classification_level { nil }
  end
end
