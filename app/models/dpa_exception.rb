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
#  tdx_ticket                       :string(255)
#  sla_agreement                    :string(255)
#  data_type_id                     :bigint           not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
class DpaException < ApplicationRecord
  belongs_to :data_type
end
