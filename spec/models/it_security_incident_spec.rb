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
end
