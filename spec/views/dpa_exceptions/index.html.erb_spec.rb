require 'rails_helper'

RSpec.describe "dpa_exceptions/index", type: :view do
  before(:each) do
    assign(:dpa_exceptions, [
      DpaException.create!(
        third_party_product_service: "MyText",
        used_by: "Used By",
        point_of_contact: "Point Of Contact",
        review_findings: "MyText",
        review_summary: "MyText",
        lsa_security_recommendation: "MyText",
        lsa_security_determination: "MyText",
        lsa_security_approval: "Lsa Security Approval",
        lsa_technology_services_approval: "Lsa Technology Services Approval",
        notes: "Notes",
        tdx_ticket: "Tdx Ticket",
        sla_agreement: "Sla Agreement",
        data_type: nil
      ),
      DpaException.create!(
        third_party_product_service: "MyText",
        used_by: "Used By",
        point_of_contact: "Point Of Contact",
        review_findings: "MyText",
        review_summary: "MyText",
        lsa_security_recommendation: "MyText",
        lsa_security_determination: "MyText",
        lsa_security_approval: "Lsa Security Approval",
        lsa_technology_services_approval: "Lsa Technology Services Approval",
        notes: "Notes",
        tdx_ticket: "Tdx Ticket",
        sla_agreement: "Sla Agreement",
        data_type: nil
      )
    ])
  end

  it "renders a list of dpa_exceptions" do
    render
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Used By".to_s, count: 2
    assert_select "tr>td", text: "Point Of Contact".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Lsa Security Approval".to_s, count: 2
    assert_select "tr>td", text: "Lsa Technology Services Approval".to_s, count: 2
    assert_select "tr>td", text: "Notes".to_s, count: 2
    assert_select "tr>td", text: "Tdx Ticket".to_s, count: 2
    assert_select "tr>td", text: "Sla Agreement".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
