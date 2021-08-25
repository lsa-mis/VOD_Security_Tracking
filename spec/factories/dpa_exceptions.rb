# == Schema Information
#
# Table name: dpa_exceptions
#
#  id                                                 :bigint           not null, primary key
#  review_date_exception_first_approval_date          :datetime
#  third_party_product_service                        :string(255)      not null
#  point_of_contact                                   :string(255)
#  lsa_security_approval                              :string(255)
#  lsa_technology_services_approval                   :string(255)
#  exception_approval_date_exception_renewal_date_due :datetime
#  sla_agreement                                      :string(255)
#  data_type_id                                       :bigint
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  deleted_at                                         :datetime
#  incomplete                                         :boolean          default(FALSE)
#  review_date_exception_review_date                  :datetime
#  dpa_exception_status_id                            :bigint           not null
#  department_id                                      :bigint           not null
#
FactoryBot.define do
  factory :dpa_exception do
    dpa_exception_status
    review_date_exception_first_approval_date { Faker::Date.in_date_period }
    third_party_product_service { Faker::String.random(length: 20..120) }
    department
    point_of_contact { Faker::String.random(length: 20..120) }
    review_findings { Faker::String.random(length: 20..120) }
    review_summary { Faker::String.random(length: 20..120) }
    lsa_security_recommendation { Faker::String.random(length: 20..120) }
    lsa_security_determination { Faker::String.random(length: 20..120) }
    lsa_security_approval { Faker::String.random(length: 20..120) }
    lsa_technology_services_approval { Faker::String.random(length: 20..120) }
    exception_approval_date_exception_renewal_date_due { Faker::Date.in_date_period }
    review_date_exception_review_date { Faker::Date.in_date_period }
    notes { Faker::String.random(length: 60..120) }
    sla_agreement { Faker::String.random(length: 60..120) }
    data_type
  end
end
