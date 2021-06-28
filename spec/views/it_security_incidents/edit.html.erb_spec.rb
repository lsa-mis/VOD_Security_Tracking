require 'rails_helper'

RSpec.describe "it_security_incidents/edit", type: :view do
  before(:each) do
    @it_security_incident = assign(:it_security_incident, ItSecurityIncident.create!(
      people_involved: "MyText",
      equipment_involved: "MyText",
      remediation_steps: "MyText",
      estimated_financial_cost: 1,
      notes: "MyText",
      it_security_incident_status: nil,
      data_type: nil
    ))
  end

  it "renders the edit it_security_incident form" do
    render

    assert_select "form[action=?][method=?]", it_security_incident_path(@it_security_incident), "post" do

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
