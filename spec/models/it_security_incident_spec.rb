# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  estimated_financial_cost       :integer
#  it_security_incident_status_id :bigint
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  deleted_at                     :datetime
#  incomplete                     :boolean          default(FALSE)
#  title                          :string(255)      not null
#
require 'rails_helper'

RSpec.describe ItSecurityIncident, type: :model do
  let!(:device) { FactoryBot.create(:device) }
  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }
  let!(:data_type) { FactoryBot.create(:data_type, { data_classification_level: data_classification_level }) }
  let!(:it_security_incident_status) { FactoryBot.create(:it_security_incident_status) }
  let!(:it_security_incident) { FactoryBot.create(:it_security_incident) }
  let!(:tdx_ticket) { FactoryBot.create(:tdx_ticket, :for_it_security_incident, records_to_tdx: it_security_incident) }

  describe "associations" do
    it "can have multiple TDX tickets" do
      expect(it_security_incident.tdx_tickets).to include(tdx_ticket)
    end

    it "can have multiple attachments" do
      it_security_incident.attachments.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(it_security_incident.attachments).to be_attached
    end

    it "belongs to a data type" do
      expect(it_security_incident.data_type).to be_present
    end

    it "belongs to an incident status" do
      expect(it_security_incident.it_security_incident_status).to be_present
    end
  end

  describe "validations" do
    it "requires a title" do
      it_security_incident.title = nil
      expect(it_security_incident).not_to be_valid
    end

    it "requires a date" do
      it_security_incident.date = nil
      expect(it_security_incident).not_to be_valid
    end

    it "requires a data type" do
      it_security_incident.data_type = nil
      expect(it_security_incident).not_to be_valid
    end

    it "validates estimated financial cost is a number when present" do
      it_security_incident.estimated_financial_cost = "not a number"
      expect(it_security_incident).not_to be_valid

      it_security_incident.estimated_financial_cost = 1000
      expect(it_security_incident).to be_valid

      it_security_incident.estimated_financial_cost = nil
      expect(it_security_incident).to be_valid
    end
  end

  it "is valid with required attributes" do
    expect(ItSecurityIncident.new(
      title: "Test Incident",
      date: "2021-03-19 16:50:16",
      people_involved: "people_involved",
      equipment_involved: "equipment_involved",
      remediation_steps: "remediation_steps",
      it_security_incident_status: it_security_incident_status,
      data_type: data_type
    )).to be_valid
  end

  it "is not valid without a data_type" do
    expect(ItSecurityIncident.new(people_involved: "people_involved", equipment_involved: "equipment_involved",
                              remediation_steps: "remediation_steps", date: "2021-03-19 16:50:16",
                              it_security_incident_status: it_security_incident_status)).to_not be_valid
  end

  it "is incomplete with empty attributes" do
    it_security_incident = ItSecurityIncident.new(date: "2021-03-19 16:50:16", people_involved: "people_involved", equipment_involved: "equipment_involved",
                            remediation_steps: "remediation_steps",
                            it_security_incident_status: it_security_incident_status, data_type: data_type)
    expect(it_security_incident.not_completed?).to be(true)
  end

  it "is complete with all attributes" do
    expect(it_security_incident.not_completed?).to be(false)
    it_security_incident.update(notes: "")
    expect(it_security_incident.not_completed?).to be(false)
  end

  it "is valid with all attributes" do
    expect(it_security_incident).to be_valid
  end

  describe "scopes" do
    describe ".active" do
      it "returns non-archived records" do
        active = FactoryBot.create(:it_security_incident, deleted_at: nil)
        archived = FactoryBot.create(:it_security_incident, deleted_at: DateTime.current)

        expect(ItSecurityIncident.active).to include(active)
        expect(ItSecurityIncident.active).not_to include(archived)
      end
    end

    describe ".archived" do
      it "returns archived records" do
        active = FactoryBot.create(:it_security_incident, deleted_at: nil)
        archived = FactoryBot.create(:it_security_incident, deleted_at: DateTime.current)

        expect(ItSecurityIncident.archived).to include(archived)
        expect(ItSecurityIncident.archived).not_to include(active)
      end
    end
  end

  describe "#archive" do
    it "sets deleted_at timestamp" do
      incident = FactoryBot.create(:it_security_incident, deleted_at: nil)
      incident.archive
      expect(incident.deleted_at).to be_present
    end
  end

  describe "#unarchive" do
    it "clears deleted_at timestamp" do
      incident = FactoryBot.create(:it_security_incident, deleted_at: DateTime.current)
      incident.unarchive
      expect(incident.deleted_at).to be_nil
    end
  end

  describe "#archived?" do
    it "returns true when deleted_at is present" do
      incident = FactoryBot.create(:it_security_incident, deleted_at: DateTime.current)
      expect(incident.archived?).to be true
    end

    it "returns false when deleted_at is nil" do
      incident = FactoryBot.create(:it_security_incident, deleted_at: nil)
      expect(incident.archived?).to be false
    end
  end

  describe "attachment validations" do
    it "validates attachment file size" do
      incident = FactoryBot.create(:it_security_incident)
      large_file = StringIO.new("x" * 21.megabytes)

      incident.attachments.attach(
        io: large_file,
        filename: 'large.pdf',
        content_type: 'application/pdf'
      )

      expect(incident).not_to be_valid
      expect(incident.errors[:attachments]).to include("is too big")
    end

    it "validates attachment file types" do
      incident = FactoryBot.create(:it_security_incident)
      invalid_file = StringIO.new("invalid content")

      incident.attachments.attach(
        io: invalid_file,
        filename: 'invalid.exe',
        content_type: 'application/x-msdownload'
      )

      expect(incident).not_to be_valid
      expect(incident.errors[:attachments]).to be_present
    end
  end

  describe ".to_csv" do
    it "generates CSV with headers" do
      incident = FactoryBot.create(:it_security_incident)
      csv = ItSecurityIncident.to_csv

      expect(csv).to be_a(String)
      expect(csv).to include("LINK")
      expect(csv).to include("TITLE")
    end

    it "includes record data in CSV" do
      incident = FactoryBot.create(:it_security_incident)
      csv = ItSecurityIncident.to_csv

      expect(csv).to include(incident.title)
    end
  end

  describe "#display_name" do
    it "returns title and id" do
      incident = FactoryBot.create(:it_security_incident, title: "Test Incident")
      expect(incident.display_name).to include("Test Incident")
      expect(incident.display_name).to include(incident.id.to_s)
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(ItSecurityIncident.ransackable_attributes).to be_an(Array)
      expect(ItSecurityIncident.ransackable_attributes).to include("title", "date")
    end
  end
end
