# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)      not null
#  owner_full_name                     :string(255)      not null
#  phone                               :string(255)
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
    name { Faker::String.random(length: 10..20) }
    owner_username { Faker::String.random(length: 6..8)}
    owner_full_name { Faker::String.random(length: 20..30)}
    phone { Faker::PhoneNumber.phone_number }
    additional_dept_contact { Faker::String.random(length: 20..120) }
    additional_dept_contact_phone { Faker::PhoneNumber.phone_number }
    support_poc { Faker::String.random(length: 20..120) }
    expected_duration_of_data_retention { Faker::String.random(length: 20..120) }
    agreements_related_to_data_types { Faker::String.random(length: 20..120)}
    review_date { Faker::Date.in_date_period }
    review_contact { Faker::String.random(length: 6..12) }
    notes { Faker::String.random(length: 20..120) }
    storage_location
    data_type
    device
    department
  end
end
