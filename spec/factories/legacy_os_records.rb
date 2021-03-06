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
    owner_username { "MyString" }
    owner_full_name { "MyString" }
    dept { "MyString" }
    phone { "MyString" }
    additional_dept_contact { "MyString" }
    additional_dept_contact_phone { "MyString" }
    support_poc { "MyString" }
    legacy_os { "MyString" }
    unique_app { "MyString" }
    unique_hardware { "MyString" }
    unique_date { "2021-03-19 16:50:16" }
    remediation { "MyString" }
    exception_approval_date { "2021-03-19 16:50:16" }
    review_date { "2021-03-19 16:50:16" }
    review_contact { "MyString" }
    justification { "MyString" }
    local_it_support_group { "MyString" }
    notes { "MyText" }
    data_type 
    device 
  end
end
