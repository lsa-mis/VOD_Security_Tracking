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
  let!(:tdx_ticket) { FactoryBot.create(:tdx_ticket, :for_sensitive_data_system, records_to_tdx: sensitive_data_system) }

  it "is valid with required attributes" do
    expect(SensitiveDataSystem.new(name: "name", owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department)).to be_valid
  end

  describe "associations" do
    it "can have multiple TDX tickets" do
      expect(sensitive_data_system.tdx_tickets).to include(tdx_ticket)
    end

    it "can have multiple attachments" do
      sensitive_data_system.attachments.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(sensitive_data_system.attachments).to be_attached
    end

    it "belongs to a device optionally" do
      expect(sensitive_data_system.device).to be_nil
      sensitive_data_system.update(device: device)
      expect(sensitive_data_system.device).to eq(device)
    end
  end

  describe "validations" do
    it "requires a name" do
      sensitive_data_system.name = nil
      expect(sensitive_data_system).not_to be_valid
    end

    it "requires an owner username" do
      sensitive_data_system.owner_username = nil
      expect(sensitive_data_system).not_to be_valid
    end

    it "requires an owner full name" do
      sensitive_data_system.owner_full_name = nil
      expect(sensitive_data_system).not_to be_valid
    end

    it "requires a department" do
      sensitive_data_system.department = nil
      expect(sensitive_data_system).not_to be_valid
    end
  end

  # this test is not working because device validation happens in the stimulus controller
  # it "is not valid without device if storage location requires device" do
  #   # storage_location = StorageLocation.new(name: "local", device_is_required: true)

  #   expect(SensitiveDataSystem.new(name: "name", owner_username: "brita", owner_full_name: "Rita Barvinok",
  #                               department: department,
  #                               storage_location: storage_location)).to be_valid
  # end

  describe "completeness" do
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

    it "is complete with all required attributes and optional attachments" do
      sensitive_data_system.attachments.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(sensitive_data_system.not_completed?).to be(false)
    end
  end
end
