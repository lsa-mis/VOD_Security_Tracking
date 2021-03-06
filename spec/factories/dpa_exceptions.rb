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
    review_date { "2021-03-19 16:47:17" }
    third_party_product_service { "MyText" }
    department_id { "MyString" }
    point_of_contact { "MyString" }
    review_findings { "MyText" }
    review_summary { "MyText" }
    lsa_security_recommendation { "MyText" }
    lsa_security_determination { "MyText" }
    lsa_security_approval { "MyString" }
    lsa_technology_services_approval { "MyString" }
    exception_approval_date { "2021-03-19 16:47:17" }
    notes { "MyString" }
    tdx_ticket { "MyString" }
    sla_agreement { "MyString" }
    data_type { nil }
  end
end
