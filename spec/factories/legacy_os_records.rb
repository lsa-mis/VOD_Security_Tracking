# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)      not null
#  owner_full_name               :string(255)      not null
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)
#  local_it_support_group        :string(255)
#  data_type_id                  :bigint
#  device_id                     :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  incomplete                    :boolean          default(FALSE)
#  department_id                 :bigint           not null
#
FactoryBot.define do
  factory :legacy_os_record do
    owner_username { Faker::Internet.username }
    owner_full_name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    additional_dept_contact { Faker::Name.name }
    additional_dept_contact_phone { Faker::PhoneNumber.phone_number }
    support_poc { Faker::Name.name }
    legacy_os { "Windows XP" }
    unique_app { Faker::App.name }
    unique_hardware { Faker::Device.model_name }
    unique_date { Faker::Date.forward(days: 90) }
    exception_approval_date { Faker::Date.backward(days: 90) }
    review_date { Faker::Date.forward(days: 180) }
    review_contact { Faker::Internet.email }
    local_it_support_group { "IT Support #{Faker::Number.number(digits: 3)}" }
    association :department
    association :device
    data_type { nil }

    trait :with_data_type do
      association :data_type
    end

    trait :with_unique_app_only do
      unique_hardware { nil }
    end

    trait :with_unique_hardware_only do
      unique_app { nil }
    end
  end
end
