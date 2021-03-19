require 'rails_helper'

RSpec.describe "sensitive_data_systems/new", type: :view do
  before(:each) do
    assign(:sensitive_data_system, SensitiveDataSystem.new(
      owner_username: "MyString",
      owner_full_name: "MyString",
      dept: "MyString",
      phone: "MyString",
      additional_dept_contact: "MyString",
      additional_dept_contact_phone: "MyString",
      support_poc: "MyString",
      expected_duration_of_data_retention: "MyText",
      agreements_related_to_data_types: "MyString",
      review_contact: "MyString",
      notes: "MyString",
      storage_location: nil,
      data_type: nil,
      device: nil
    ))
  end

  it "renders new sensitive_data_system form" do
    render

    assert_select "form[action=?][method=?]", sensitive_data_systems_path, "post" do

      assert_select "input[name=?]", "sensitive_data_system[owner_username]"

      assert_select "input[name=?]", "sensitive_data_system[owner_full_name]"

      assert_select "input[name=?]", "sensitive_data_system[dept]"

      assert_select "input[name=?]", "sensitive_data_system[phone]"

      assert_select "input[name=?]", "sensitive_data_system[additional_dept_contact]"

      assert_select "input[name=?]", "sensitive_data_system[additional_dept_contact_phone]"

      assert_select "input[name=?]", "sensitive_data_system[support_poc]"

      assert_select "textarea[name=?]", "sensitive_data_system[expected_duration_of_data_retention]"

      assert_select "input[name=?]", "sensitive_data_system[agreements_related_to_data_types]"

      assert_select "input[name=?]", "sensitive_data_system[review_contact]"

      assert_select "input[name=?]", "sensitive_data_system[notes]"

      assert_select "input[name=?]", "sensitive_data_system[storage_location_id]"

      assert_select "input[name=?]", "sensitive_data_system[data_type_id]"

      assert_select "input[name=?]", "sensitive_data_system[device_id]"
    end
  end
end
