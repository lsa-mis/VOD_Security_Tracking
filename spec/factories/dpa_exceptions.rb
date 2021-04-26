# == Schema Information
#
# Table name: dpa_exceptions
#
#  id                               :bigint           not null, primary key
#  review_date                      :datetime
#  third_party_product_service      :text(65535)
#  used_by                          :string(255)
#  point_of_contact                 :string(255)
#  review_findings                  :text(65535)
#  review_summary                   :text(65535)
#  lsa_security_recommendation      :text(65535)
#  lsa_security_determination       :text(65535)
#  lsa_security_approval            :string(255)
#  lsa_technology_services_approval :string(255)
#  exception_approval_date          :datetime
#  notes                            :string(255)
#  sla_agreement                    :string(255)
#  data_type_id                     :bigint           not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  deleted_at                       :datetime
#
FactoryBot.define do
  factory :dpa_exception do
    review_date { "2021-03-19 16:47:17" }
    third_party_product_service { "MyText" }
    used_by { "MyString" }
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
