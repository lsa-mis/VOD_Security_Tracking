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
  let!(:dpa_exception) { FactoryBot.create(:dpa_exception) }
  let!(:tdx_ticket) { FactoryBot.create(:tdx_ticket, :for_dpa_exception, records_to_tdx: dpa_exception) }

  describe "associations" do
    it "can have multiple TDX tickets" do
      expect(dpa_exception.tdx_tickets).to include(tdx_ticket)
    end

    it "can have multiple attachments" do
      dpa_exception.attachments.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(dpa_exception.attachments).to be_attached
    end

    it "belongs to a department" do
      expect(dpa_exception.department).to be_present
    end

    it "belongs to a status" do
      expect(dpa_exception.dpa_exception_status).to be_present
    end

    it "can belong to a data type" do
      dpa_exception.data_type = data_type
      expect(dpa_exception).to be_valid
    end
  end

  describe "validations" do
    it "requires a third party product service" do
      dpa_exception.third_party_product_service = nil
      expect(dpa_exception).not_to be_valid
    end

    it "requires a department" do
      dpa_exception.department = nil
      expect(dpa_exception).not_to be_valid
    end

    it "requires a status" do
      dpa_exception.dpa_exception_status = nil
      expect(dpa_exception).not_to be_valid
    end

    it "requires a first approval date" do
      dpa_exception.review_date_exception_first_approval_date = nil
      expect(dpa_exception).not_to be_valid
    end

    it 'validates review date is after first approval date when present' do
      # Set first approval date to a specific date
      first_approval_date = Date.new(2024, 1, 1)

      # Create a new DSA exception with review date before first approval
      dpa_exception = FactoryBot.build(:dpa_exception,
        review_date_exception_first_approval_date: first_approval_date,
        review_date_exception_review_date: first_approval_date - 1.day,
        third_party_product_service: "Test Service",
        department: department,
        dpa_exception_status: dpa_exception_status)

      # Should not be valid because review date is before first approval
      expect(dpa_exception).not_to be_valid
      expect(dpa_exception.errors[:review_date_exception_review_date]).to include("must be after the first approval date")

      # Now set review date after first approval
      dpa_exception.review_date_exception_review_date = first_approval_date + 1.day
      expect(dpa_exception).to be_valid
    end
  end

  it "is valid with required attributes" do
    # Create a new instance instead of modifying shared test data
    new_status = FactoryBot.create(:dpa_exception_status)
    new_department = FactoryBot.create(:department)

    dpa_exception = DpaException.new(
      dpa_exception_status: new_status,
      review_date_exception_first_approval_date: "2021-03-19 16:50:16",
      third_party_product_service: "third_party_product_service",
      department: new_department
    )
    expect(dpa_exception).to be_valid
  end

  it "is incomplete with empty attributes" do
    dpa_exception = DpaException.new(
      dpa_exception_status: dpa_exception_status,
      review_date_exception_first_approval_date: "2021-03-19 16:50:16",
      third_party_product_service: "third_party_product_service",
      department: department
    )
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
    dpa_exception.update(notes: "")
    expect(dpa_exception.not_completed?).to be(false)
    dpa_exception.destroy
  end

  describe "scopes" do
    describe ".active" do
      it "returns non-archived records" do
        active = FactoryBot.create(:dpa_exception)
        archived = FactoryBot.create(:dpa_exception)
        archived.update_column(:deleted_at, DateTime.current)

        expect(DpaException.active).to include(active)
        expect(DpaException.active).not_to include(archived)
      end
    end

    describe ".archived" do
      it "returns archived records" do
        active = FactoryBot.create(:dpa_exception)
        archived = FactoryBot.create(:dpa_exception)
        archived.update_column(:deleted_at, DateTime.current)

        expect(DpaException.archived).to include(archived)
        expect(DpaException.archived).not_to include(active)
      end
    end
  end

  describe "#archive" do
    it "sets deleted_at timestamp" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      dpa_exception.archive
      expect(dpa_exception.deleted_at).to be_present
    end
  end

  describe "#unarchive" do
    it "clears deleted_at timestamp" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      dpa_exception.update_column(:deleted_at, DateTime.current)
      dpa_exception.unarchive
      expect(dpa_exception.deleted_at).to be_nil
    end
  end

  describe "#archived?" do
    it "returns true when deleted_at is present" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      dpa_exception.update_column(:deleted_at, DateTime.current)
      expect(dpa_exception.archived?).to be true
    end

    it "returns false when deleted_at is nil" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      expect(dpa_exception.archived?).to be false
    end
  end

  describe "attachment validations" do
    it "validates attachment file size" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      large_file = StringIO.new("x" * 21.megabytes)

      dpa_exception.attachments.attach(
        io: large_file,
        filename: 'large.pdf',
        content_type: 'application/pdf'
      )

      expect(dpa_exception).not_to be_valid
      expect(dpa_exception.errors[:attachments]).to include("is too big")
    end

    it "validates attachment file types" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      invalid_file = StringIO.new("invalid content")

      dpa_exception.attachments.attach(
        io: invalid_file,
        filename: 'invalid.exe',
        content_type: 'application/x-msdownload'
      )

      expect(dpa_exception).not_to be_valid
      expect(dpa_exception.errors[:attachments]).to be_present
    end

    it "accepts valid attachment types" do
      dpa_exception = FactoryBot.create(:dpa_exception)
      pdf_file = File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf'))

      dpa_exception.attachments.attach(
        io: pdf_file,
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )

      expect(dpa_exception).to be_valid
    end
  end

  describe ".to_csv" do
    it "generates CSV with headers" do
      FactoryBot.create(:dpa_exception)
      csv = DpaException.to_csv

      expect(csv).to be_a(String)
      expect(csv).to include("LINK")
      expect(csv).to include("THIRD PARTY PRODUCT SERVICE")
    end

    it "includes record data in CSV" do
      FactoryBot.create(:dpa_exception, third_party_product_service: "Test Service Name")
      csv = DpaException.to_csv

      # CSV should contain the record
      expect(csv).to include("Test Service Name")
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(DpaException.ransackable_attributes).to be_an(Array)
      expect(DpaException.ransackable_attributes).to include("third_party_product_service", "department_id")
    end
  end

  describe ".ransackable_associations" do
    it "returns an array of searchable associations" do
      expect(DpaException.ransackable_associations).to be_an(Array)
      expect(DpaException.ransackable_associations).to include("department", "data_type")
    end
  end

  describe "#display_name" do
    it "returns third party product service name" do
      dpa_exception = FactoryBot.create(:dpa_exception, third_party_product_service: "Test Service")
      expect(dpa_exception.display_name).to eq("Test Service")
    end
  end
end
