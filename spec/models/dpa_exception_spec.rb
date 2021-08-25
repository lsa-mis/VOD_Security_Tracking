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
require 'rails_helper'

RSpec.describe DpaException, type: :model do
  let!(:device) { FactoryBot.create(:device) }
  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }
  let!(:data_type) { FactoryBot.create(:data_type, { data_classification_level: data_classification_level }) }

  it "is valid with valid attributes" do
    expect(DpaException.new(review_date_exception_first_approval_date: "2021-03-19 16:50:16", 
                            third_party_product_service: "third_party_product_service",
                            used_by: "used_by")).to be_valid
  end

  # it "is not valid without a data_type" do
  #   expect(DpaException.new(third_party_product_service: "third_party_product_service", review_date_exception_first_approval_date: "2021-03-19 16:50:16", used_by: "used_by",
  #                             lsa_security_approval: "lsa_security_approval", lsa_technology_services_approval: "lsa_technology_services_approval",
  #                             exception_approval_date_exception_renewal_date_due: "2021-03-19 16:50:16",
  #                             review_date_exception_review_date: "2021-03-19 16:50:16")).to_not be_valid
  # end


end
