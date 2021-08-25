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
  let!(:department) { FactoryBot.create(:department) }
  let!(:dpa_exception_status) { FactoryBot.create(:dpa_exception_status) }
  # let!(:dpa_exception) { FactoryBot.create(:dpa_exception) }

  it "is valid with required attributes" do
    dpa_exception = DpaException.new(dpa_exception_status: dpa_exception_status, review_date_exception_first_approval_date: "2021-03-19 16:50:16", 
                            third_party_product_service: "third_party_product_service",
                            department: department)
    expect(dpa_exception).to be_valid
    dpa_exception.destroy
  
  end

  it "is incomplete with empty attributes" do
    dpa_exception = DpaException.new(dpa_exception_status: dpa_exception_status, review_date_exception_first_approval_date: "2021-03-19 16:50:16", 
                            third_party_product_service: "third_party_product_service",
                            department: department)
    expect(dpa_exception.not_completed?).to be(true)
    dpa_exception.destroy
  end

  it "is valid with all attributes" do
    dpa_exception = FactoryBot.create(:dpa_exception)
    expect(dpa_exception).to be_valid
    dpa_exception.destroy
  end

  it "is complete with all attributes" do
    dpa_exception = FactoryBot.create(:dpa_exception)
    expect(dpa_exception.not_completed?).to be(false)
    dpa_exception.destroy
  end

end

# working test
