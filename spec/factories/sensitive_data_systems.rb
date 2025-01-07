# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)      not null
#  owner_full_name                     :string(255)      not null
#  phone                              :string(255)
#  additional_dept_contact             :string(255)
#  additional_dept_contact_phone       :string(255)
#  support_poc                         :string(255)
#  expected_duration_of_data_retention :string(255)
#  agreements_related_to_data_types    :string(255)
#  review_date                         :datetime
#  review_contact                      :string(255)
#  storage_location_id                 :bigint
#  data_type_id                        :bigint
#  device_id                           :bigint
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deleted_at                          :datetime
#  incomplete                          :boolean          default(FALSE)
#  name                                :string(255)      not null
#  department_id                       :bigint           not null
#
FactoryBot.define do
  factory :sensitive_data_system do
    name { Faker::App.name }
    owner_username { Faker::Internet.username }
    owner_full_name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    additional_dept_contact { Faker::Name.name }
    additional_dept_contact_phone { Faker::PhoneNumber.phone_number }
    support_poc { Faker::Name.name }
    expected_duration_of_data_retention { "#{Faker::Number.number(digits: 2)} months" }
    agreements_related_to_data_types { Faker::Lorem.sentence }
    review_date { Faker::Date.forward(days: 90) }
    review_contact { Faker::Internet.email }
    association :department
    storage_location { nil }
    data_type { nil }
    device { nil }

    trait :with_device do
      association :device
    end

    trait :with_storage_location do
      association :storage_location
    end

    trait :with_data_type do
      association :data_type
    end
  end
end
