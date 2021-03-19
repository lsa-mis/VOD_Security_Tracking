require 'rails_helper'

RSpec.describe "dpa_exceptions/edit", type: :view do
  before(:each) do
    @dpa_exception = assign(:dpa_exception, DpaException.create!(
      third_party_product_service: "MyText",
      used_by: "MyString",
      point_of_contact: "MyString",
      review_findings: "MyText",
      review_summary: "MyText",
      lsa_security_recommendation: "MyText",
      lsa_security_determination: "MyText",
      lsa_security_approval: "MyString",
      lsa_technology_services_approval: "MyString",
      notes: "MyString",
      tdx_ticket: "MyString",
      sla_agreement: "MyString",
      data_type: nil
    ))
  end

  it "renders the edit dpa_exception form" do
    render

    assert_select "form[action=?][method=?]", dpa_exception_path(@dpa_exception), "post" do

      assert_select "textarea[name=?]", "dpa_exception[third_party_product_service]"

      assert_select "input[name=?]", "dpa_exception[used_by]"

      assert_select "input[name=?]", "dpa_exception[point_of_contact]"

      assert_select "textarea[name=?]", "dpa_exception[review_findings]"

      assert_select "textarea[name=?]", "dpa_exception[review_summary]"

      assert_select "textarea[name=?]", "dpa_exception[lsa_security_recommendation]"

      assert_select "textarea[name=?]", "dpa_exception[lsa_security_determination]"

      assert_select "input[name=?]", "dpa_exception[lsa_security_approval]"

      assert_select "input[name=?]", "dpa_exception[lsa_technology_services_approval]"

      assert_select "input[name=?]", "dpa_exception[notes]"

      assert_select "input[name=?]", "dpa_exception[tdx_ticket]"

      assert_select "input[name=?]", "dpa_exception[sla_agreement]"

      assert_select "input[name=?]", "dpa_exception[data_type_id]"
    end
  end
end
