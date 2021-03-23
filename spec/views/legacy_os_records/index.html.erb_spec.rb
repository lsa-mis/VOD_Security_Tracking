require 'rails_helper'

RSpec.describe "legacy_os_records/index", type: :view do
  before(:each) do
    assign(:legacy_os_records, [
      LegacyOsRecord.create!(
        owner_username: "Owner Username",
        owner_full_name: "Owner Full Name",
        dept: "Dept",
        phone: "Phone",
        additional_dept_contact: "Additional Dept Contact",
        additional_dept_contact_phone: "Additional Dept Contact Phone",
        support_poc: "Support Poc",
        legacy_os: "Legacy Os",
        unique_app: "Unique App",
        unique_hardware: "Unique Hardware",
        remediation: "Remediation",
        review_contact: "Review Contact",
        justification: "Justification",
        local_it_support_group: "Local It Support Group",
        notes: "MyText",
        data_type: nil,
        device: nil
      ),
      LegacyOsRecord.create!(
        owner_username: "Owner Username",
        owner_full_name: "Owner Full Name",
        dept: "Dept",
        phone: "Phone",
        additional_dept_contact: "Additional Dept Contact",
        additional_dept_contact_phone: "Additional Dept Contact Phone",
        support_poc: "Support Poc",
        legacy_os: "Legacy Os",
        unique_app: "Unique App",
        unique_hardware: "Unique Hardware",
        remediation: "Remediation",
        review_contact: "Review Contact",
        justification: "Justification",
        local_it_support_group: "Local It Support Group",
        notes: "MyText",
        data_type: nil,
        device: nil
      )
    ])
  end

  it "renders a list of legacy_os_records" do
    render
    assert_select "tr>td", text: "Owner Username".to_s, count: 2
    assert_select "tr>td", text: "Owner Full Name".to_s, count: 2
    assert_select "tr>td", text: "Dept".to_s, count: 2
    assert_select "tr>td", text: "Phone".to_s, count: 2
    assert_select "tr>td", text: "Additional Dept Contact".to_s, count: 2
    assert_select "tr>td", text: "Additional Dept Contact Phone".to_s, count: 2
    assert_select "tr>td", text: "Support Poc".to_s, count: 2
    assert_select "tr>td", text: "Legacy Os".to_s, count: 2
    assert_select "tr>td", text: "Unique App".to_s, count: 2
    assert_select "tr>td", text: "Unique Hardware".to_s, count: 2
    assert_select "tr>td", text: "Remediation".to_s, count: 2
    assert_select "tr>td", text: "Review Contact".to_s, count: 2
    assert_select "tr>td", text: "Justification".to_s, count: 2
    assert_select "tr>td", text: "Local It Support Group".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
