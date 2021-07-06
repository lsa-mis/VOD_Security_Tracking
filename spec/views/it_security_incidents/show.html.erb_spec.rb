require 'rails_helper'

RSpec.describe "it_security_incidents/show", type: :view do
  before(:each) do
    @it_security_incident = assign(:it_security_incident, ItSecurityIncident.create!(
      people_involved: "MyText",
      equipment_involved: "MyText",
      remediation_steps: "MyText",
      estimated_financial_cost: 2,
      notes: "MyText",
      it_security_incident_status: nil,
      data_type: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
