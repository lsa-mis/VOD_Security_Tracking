require 'rails_helper'

RSpec.describe "it_security_incidents/index", type: :view do
  before(:each) do
    assign(:it_security_incidents, [
      ItSecurityIncident.create!(
        people_involved: "MyText",
        equipment_involved: "MyText",
        remediation_steps: "MyText",
        estimated_finacial_cost: 2,
        notes: "MyText",
        it_security_incident_status: nil,
        data_type: nil
      ),
      ItSecurityIncident.create!(
        people_involved: "MyText",
        equipment_involved: "MyText",
        remediation_steps: "MyText",
        estimated_finacial_cost: 2,
        notes: "MyText",
        it_security_incident_status: nil,
        data_type: nil
      )
    ])
  end

  it "renders a list of it_security_incidents" do
    render
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
