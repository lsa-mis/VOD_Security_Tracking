require 'rails_helper'

RSpec.describe "sensitive_data_systems/index", type: :view do
  before(:each) do
    assign(:sensitive_data_systems, [
      SensitiveDataSystem.create!(
        owner_username: "Owner Username",
        owner_full_name: "Owner Full Name",
        dept: "Dept",
        phone: "Phone",
        additional_dept_contact: "Additional Dept Contact",
        additional_dept_contact_phone: "Additional Dept Contact Phone",
        support_poc: "Support Poc",
        expected_duration_of_data_retention: "MyText",
        agreements_related_to_data_types: "Agreements Related To Data Types",
        review_contact: "Review Contact",
        notes: "Notes",
        storage_location: nil,
        data_type: nil,
        device: nil
      ),
      SensitiveDataSystem.create!(
        owner_username: "Owner Username",
        owner_full_name: "Owner Full Name",
        dept: "Dept",
        phone: "Phone",
        additional_dept_contact: "Additional Dept Contact",
        additional_dept_contact_phone: "Additional Dept Contact Phone",
        support_poc: "Support Poc",
        expected_duration_of_data_retention: "MyText",
        agreements_related_to_data_types: "Agreements Related To Data Types",
        review_contact: "Review Contact",
        notes: "Notes",
        storage_location: nil,
        data_type: nil,
        device: nil
      )
    ])
  end

  it "renders a list of sensitive_data_systems" do
    render
    assert_select "tr>td", text: "Owner Username".to_s, count: 2
    assert_select "tr>td", text: "Owner Full Name".to_s, count: 2
    assert_select "tr>td", text: "Dept".to_s, count: 2
    assert_select "tr>td", text: "Phone".to_s, count: 2
    assert_select "tr>td", text: "Additional Dept Contact".to_s, count: 2
    assert_select "tr>td", text: "Additional Dept Contact Phone".to_s, count: 2
    assert_select "tr>td", text: "Support Poc".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Agreements Related To Data Types".to_s, count: 2
    assert_select "tr>td", text: "Review Contact".to_s, count: 2
    assert_select "tr>td", text: "Notes".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
