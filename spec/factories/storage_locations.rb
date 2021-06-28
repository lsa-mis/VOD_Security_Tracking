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
    name { "MyString" }
    description { "MyString" }
    description_link { "MyString" }
  end
end
