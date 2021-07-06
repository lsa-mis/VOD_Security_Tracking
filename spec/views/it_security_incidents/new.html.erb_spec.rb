require 'rails_helper'

RSpec.describe "it_security_incidents/new", type: :view do
  before(:each) do
    assign(:it_security_incident, ItSecurityIncident.new(
      people_involved: "MyText",
      equipment_involved: "MyText",
      remediation_steps: "MyText",
      estimated_financial_cost: 1,
      notes: "MyText",
      it_security_incident_status: nil,
      data_type: nil
    ))
  end

  it "renders new it_security_incident form" do
    render

    assert_select "form[action=?][method=?]", it_security_incidents_path, "post" do

      assert_select "textarea[name=?]", "it_security_incident[people_involved]"

      assert_select "textarea[name=?]", "it_security_incident[equipment_involved]"

      assert_select "textarea[name=?]", "it_security_incident[remediation_steps]"

      assert_select "input[name=?]", "it_security_incident[estimated_financial_cost]"

      assert_select "textarea[name=?]", "it_security_incident[notes]"

      assert_select "input[name=?]", "it_security_incident[it_security_incident_status_id]"

      assert_select "input[name=?]", "it_security_incident[data_type_id]"
    end
  end
end
