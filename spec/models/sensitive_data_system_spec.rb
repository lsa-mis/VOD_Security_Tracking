# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)      not null
#  owner_full_name                     :string(255)      not null
#  phone                               :string(255)
#  additional_dept_contact             :string(255)
#  additional_dept_contact_phone       :string(255)
#  support_poc                         :string(255)
#  expected_duration_of_data_retention :string(255)
#  agreements_related_to_data_types    :string(255)
#  review_date                         :datetime
#  review_contact                      :string(255)
#  storage_location_id                 :bigint
#  data_type_id                        :bigint
#  device_id                           :bigint
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deleted_at                          :datetime
#  incomplete                          :boolean          default(FALSE)
#  name                                :string(255)      not null
#  department_id                       :bigint           not null
#
require 'rails_helper'

RSpec.describe SensitiveDataSystem, type: :model do
  let!(:device) { FactoryBot.create(:device) }
  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }
  let!(:data_type) { FactoryBot.create(:data_type, { data_classification_level: data_classification_level }) }
  let!(:storage_location) { FactoryBot.create(:storage_location) }
  let!(:department) { FactoryBot.create(:department) }
  let!(:sensitive_data_system) { FactoryBot.create(:sensitive_data_system) }

  it "is valid with required attributes" do
    expect(SensitiveDataSystem.new(name: "name", owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department)).to be_valid
  end

  # this test is not working because device validation happens in the stimulus controller
  # it "is not valid without device if storage location requires device" do
  #   # storage_location = StorageLocation.new(name: "local", device_is_required: true)

  #   expect(SensitiveDataSystem.new(name: "name", owner_username: "brita", owner_full_name: "Rita Barvinok",
  #                               department: department, 
  #                               storage_location: storage_location)).to be_valid
  # end

  it "is incomplete with empty attributes" do
    sensitive_data_system = SensitiveDataSystem.new(name: "name", owner_username: "brita", owner_full_name: "Rita Barvinok",
                            department: department)
    expect(sensitive_data_system.not_completed?).to be(true)
  end

  it "is complete with all attributes" do
    expect(sensitive_data_system.not_completed?).to be(false)
    sensitive_data_system.update(notes: "")
    expect(sensitive_data_system.not_completed?).to be(false)

  end
end
