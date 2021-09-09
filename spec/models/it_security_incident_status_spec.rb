# == Schema Information
#
# Table name: it_security_incident_statuses
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe ItSecurityIncidentStatus, type: :model do

  it "should have a unique name" do
    ItSecurityIncidentStatus.create!(name: 'Low')
    it_security_incident_status = ItSecurityIncidentStatus.new(name: 'Low')
    expect(it_security_incident_status).to_not be_valid
    it_security_incident_status.errors[:name].include?("has already be taken")
  end

  it "is not valid without name" do
    expect(ItSecurityIncidentStatus.new(description: "description")).to_not be_valid
  end

end
