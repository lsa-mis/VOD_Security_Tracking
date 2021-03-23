# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)
#  owner_full_name               :string(255)
#  dept                          :string(255)
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  remediation                   :string(255)
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)
#  justification                 :string(255)
#  local_it_support_group        :string(255)
#  notes                         :text(65535)
#  data_type_id                  :bigint           not null
#  device_id                     :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
    data_type { nil }
    device { nil }
  end
end
