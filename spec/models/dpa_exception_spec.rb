# == Schema Information
#
# Table name: dpa_exceptions
#
#  id                               :bigint           not null, primary key
#  review_date                      :datetime         not null
#  third_party_product_service      :text(65535)      not null
#  used_by                          :string(255)      not null
#  point_of_contact                 :string(255)
#  review_findings                  :text(65535)
#  review_summary                   :text(65535)
#  lsa_security_recommendation      :text(65535)
#  lsa_security_determination       :text(65535)
#  lsa_security_approval            :string(255)      not null
#  lsa_technology_services_approval :string(255)      not null
#  exception_approval_date          :datetime         not null
#  notes                            :string(255)
#  sla_agreement                    :string(255)
#  data_type_id                     :bigint           not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  deleted_at                       :datetime
#
require 'rails_helper'

RSpec.describe DpaException, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
