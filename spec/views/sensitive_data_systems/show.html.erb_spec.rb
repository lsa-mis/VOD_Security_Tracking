require 'rails_helper'

RSpec.describe "sensitive_data_systems/show", type: :view do
  before(:each) do
    @sensitive_data_system = assign(:sensitive_data_system, SensitiveDataSystem.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Owner Username/)
    expect(rendered).to match(/Owner Full Name/)
    expect(rendered).to match(/Dept/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Additional Dept Contact/)
    expect(rendered).to match(/Additional Dept Contact Phone/)
    expect(rendered).to match(/Support Poc/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Agreements Related To Data Types/)
    expect(rendered).to match(/Review Contact/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
