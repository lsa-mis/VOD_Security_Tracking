require 'rails_helper'

RSpec.describe "legacy_os_records/show", type: :view do
  before(:each) do
    @legacy_os_record = assign(:legacy_os_record, LegacyOsRecord.create!(
      owner_username: "Owner Username",
      owner_full_name: "Owner Full Name",
      dept: "Department",
      phone: "Phone",
      additional_dept_contact: "Additional Department Contact",
      additional_dept_contact_phone: "Additional Department Contact Phone",
      support_poc: "Support Poc",
      legacy_os: "Legacy OS",
      unique_app: "Unique App",
      unique_hardware: "Unique Hardware",
      remediation: "Remediation",
      review_contact: "Review Contact",
      justification: "Justification",
      local_it_support_group: "Local It Support Group",
      notes: "MyText",
      data_type: nil,
      device: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Owner Username/)
    expect(rendered).to match(/Owner Full Name/)
    expect(rendered).to match(/Department/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Additional Department Contact/)
    expect(rendered).to match(/Additional Department Contact Phone/)
    expect(rendered).to match(/Support Poc/)
    expect(rendered).to match(/Legacy OS/)
    expect(rendered).to match(/Unique App/)
    expect(rendered).to match(/Unique Hardware/)
    expect(rendered).to match(/Remediation/)
    expect(rendered).to match(/Review Contact/)
    expect(rendered).to match(/Justification/)
    expect(rendered).to match(/Local It Support Group/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
