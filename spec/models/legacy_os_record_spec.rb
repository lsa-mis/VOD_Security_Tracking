# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)      not null
#  owner_full_name               :string(255)      not null
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)
#  local_it_support_group        :string(255)
#  data_type_id                  :bigint
#  device_id                     :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  incomplete                    :boolean          default(FALSE)
#  department_id                 :bigint           not null
#
require 'rails_helper'

RSpec.describe LegacyOsRecord, type: :model do

  let!(:device) { FactoryBot.create(:device) }
  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }
  let!(:data_type) { FactoryBot.create(:data_type, { data_classification_level: data_classification_level }) }
  let!(:department) { FactoryBot.create(:department) }
  let!(:legacy_os_record) { FactoryBot.create(:legacy_os_record, department: department) }
  let!(:tdx_ticket) { FactoryBot.create(:tdx_ticket, :for_legacy_os_record, records_to_tdx: legacy_os_record) }

  describe "associations" do
    it "can have multiple TDX tickets" do
      expect(legacy_os_record.tdx_tickets).to include(tdx_ticket)
    end

    it "can have multiple attachments" do
      legacy_os_record.attachments.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(legacy_os_record.attachments).to be_attached
    end

    it "belongs to a device" do
      expect(legacy_os_record.device).to be_present
    end

    it "belongs to a department" do
      expect(legacy_os_record.department).to eq(department)
    end
  end

  describe "validations" do
    it "requires an owner username" do
      legacy_os_record.owner_username = nil
      expect(legacy_os_record).not_to be_valid
    end

    it "requires an owner full name" do
      legacy_os_record.owner_full_name = nil
      expect(legacy_os_record).not_to be_valid
    end

    it "requires a department" do
      legacy_os_record.department = nil
      expect(legacy_os_record).not_to be_valid
    end

    it "requires either unique_app or unique_hardware" do
      legacy_os_record.unique_app = nil
      legacy_os_record.unique_hardware = nil
      expect(legacy_os_record).not_to be_valid

      legacy_os_record.unique_app = "test app"
      expect(legacy_os_record).to be_valid

      legacy_os_record.unique_app = nil
      legacy_os_record.unique_hardware = "test hardware"
      expect(legacy_os_record).to be_valid
    end
  end

  it "is valid with required attributes (including only unique_app)" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_app: "unique_app",
                              device: device)).to be_valid
  end

  it "is valid with required attributes (including only unique_hardware)" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_hardware: "unique_hardware",
                              device: device)).to be_valid
  end

  it "is valid with required attributes (including both unique_app and unique_hardware)" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_hardware: "unique_hardware", unique_app: "unique_app",
                              device: device)).to be_valid
  end

  it "is valid without a data_type" do
    device = Device.new(serial: "C02ZF95GLVDL")
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation",
                              review_contact: "review_contact", department: department, phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16", unique_app: "unique_app",
                              device: device)).to be_valid
  end

  it "is not valid without a device" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation",
                              review_contact: "review_contact", department: department, phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16", unique_app: "unique_app",
                              data_type: data_type)).to_not be_valid
  end

  it "is not valid without unique_app and unique_hardware" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation",
                              review_contact: "review_contact", department: department, phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16",
                              device: device)).to_not be_valid
  end

  it "is incomplete with empty attributes" do
    legacy_os_record = LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_app: "unique_app",
                              device: device)
    expect(legacy_os_record.not_completed?).to be(true)
  end

  xit "is complete with all attributes" do
    expect(legacy_os_record.not_completed?).to be(false)
    legacy_os_record.update(notes: "")
    expect(legacy_os_record.not_completed?).to be(false)
    legacy_os_record.update(unique_app: "")
    expect(legacy_os_record.not_completed?).to be(false)
    legacy_os_record.update(unique_app: "unique_app", unique_hardware: "")
    expect(legacy_os_record.not_completed?).to be(false)
  end

  it "is valid with all attributes" do
    expect(legacy_os_record).to be_valid
  end

  describe "scopes" do
    describe ".active" do
      it "returns non-archived records" do
        active = FactoryBot.create(:legacy_os_record, deleted_at: nil)
        archived = FactoryBot.create(:legacy_os_record, deleted_at: DateTime.current)

        expect(LegacyOsRecord.active).to include(active)
        expect(LegacyOsRecord.active).not_to include(archived)
      end
    end

    describe ".archived" do
      it "returns archived records" do
        active = FactoryBot.create(:legacy_os_record, deleted_at: nil)
        archived = FactoryBot.create(:legacy_os_record, deleted_at: DateTime.current)

        expect(LegacyOsRecord.archived).to include(archived)
        expect(LegacyOsRecord.archived).not_to include(active)
      end
    end
  end

  describe "#archive" do
    it "sets deleted_at timestamp" do
      record = FactoryBot.create(:legacy_os_record, deleted_at: nil)
      record.archive
      expect(record.deleted_at).to be_present
    end
  end

  describe "#unarchive" do
    it "clears deleted_at timestamp" do
      record = FactoryBot.create(:legacy_os_record, deleted_at: DateTime.current)
      record.unarchive
      expect(record.deleted_at).to be_nil
    end
  end

  describe "#archived?" do
    it "returns true when deleted_at is present" do
      record = FactoryBot.create(:legacy_os_record, deleted_at: DateTime.current)
      expect(record.archived?).to be true
    end

    it "returns false when deleted_at is nil" do
      record = FactoryBot.create(:legacy_os_record, deleted_at: nil)
      expect(record.archived?).to be false
    end
  end

  describe "attachment validations" do
    it "validates attachment file size" do
      record = FactoryBot.create(:legacy_os_record)
      large_file = StringIO.new("x" * 21.megabytes)

      record.attachments.attach(
        io: large_file,
        filename: 'large.pdf',
        content_type: 'application/pdf'
      )

      expect(record).not_to be_valid
      expect(record.errors[:attachments]).to include("is too big")
    end
  end

  describe ".to_csv" do
    it "generates CSV with headers" do
      record = FactoryBot.create(:legacy_os_record)
      csv = LegacyOsRecord.to_csv

      expect(csv).to be_a(String)
      expect(csv).to include("LINK")
      expect(csv).to include("OWNER USERNAME")
    end
  end

  describe "#display_name" do
    it "returns legacy OS and id" do
      record = FactoryBot.create(:legacy_os_record, legacy_os: "Windows XP")
      expect(record.display_name).to include("Windows XP")
      expect(record.display_name).to include(record.id.to_s)
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(LegacyOsRecord.ransackable_attributes).to be_an(Array)
      expect(LegacyOsRecord.ransackable_attributes).to include("legacy_os", "owner_username")
    end
  end
end
