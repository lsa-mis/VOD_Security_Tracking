require 'rails_helper'

RSpec.describe "dpa_exceptions/show", type: :view do
  before(:each) do
    @dpa_exception = assign(:dpa_exception, DpaException.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Used By/)
    expect(rendered).to match(/Point Of Contact/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Lsa Security Approval/)
    expect(rendered).to match(/Lsa Technology Services Approval/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(/Tdx Ticket/)
    expect(rendered).to match(/Sla Agreement/)
    expect(rendered).to match(//)
  end
end
