# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  people_involved                :text(65535)      not null
#  equipment_involved             :text(65535)      not null
#  remediation_steps              :text(65535)      not null
#  estimated_finacial_cost        :integer
#  notes                          :text(65535)
#  it_security_incident_status_id :bigint
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  deleted_at                     :datetime
#  incomplete                     :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe ItSecurityIncident, type: :model do
  let!(:device) { FactoryBot.create(:device) }
  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }
  let!(:data_type) { FactoryBot.create(:data_type, { data_classification_level: data_classification_level }) }
  let!(:it_security_incident_status) { FactoryBot.create(:it_security_incident_status) }

  it "is valid with valid attributes" do
    expect(ItSecurityIncident.new(date: "2021-03-19 16:50:16", people_involved: "people_involved", equipment_involved: "equipment_involved", 
                              remediation_steps: "remediation_steps", date: "2021-03-19 16:50:16",
                              it_security_incident_status: it_security_incident_status, data_type: data_type)).to be_valid
  end

  it "is not valid without a data_type" do
    expect(ItSecurityIncident.new(people_involved: "people_involved", equipment_involved: "equipment_involved", 
                              remediation_steps: "remediation_steps", date: "2021-03-19 16:50:16",
                              it_security_incident_status: it_security_incident_status)).to_not be_valid
  end
end
