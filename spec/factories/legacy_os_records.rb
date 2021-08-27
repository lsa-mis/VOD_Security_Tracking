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
    owner_username { Faker::String.random(length: 6..8) }
    owner_full_name { Faker::String.random(length: 20..30) }
    phone { Faker::PhoneNumber.phone_number }
    additional_dept_contact { Faker::String.random(length: 20..120) }
    additional_dept_contact_phone { Faker::PhoneNumber.phone_number }
    support_poc { Faker::String.random(length: 20..120) }
    legacy_os { Faker::String.random(length: 20..120) }
    unique_app { Faker::String.random(length: 20..120) }
    unique_hardware { Faker::String.random(length: 20..120) }
    unique_date { Faker::Date.in_date_period }
    remediation { Faker::String.random(length: 20..120)}
    exception_approval_date { Faker::Date.in_date_period }
    review_date { Faker::Date.in_date_period }
    review_contact { Faker::String.random(length: 20..120)}
    justification { Faker::String.random(length: 20..120) }
    local_it_support_group { Faker::String.random(length: 10..20) }
    notes { Faker::String.random(length: 20..120) }
    data_type 
    device
    department
  end
end
