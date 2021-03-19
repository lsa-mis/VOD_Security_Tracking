require 'rails_helper'

RSpec.describe "legacy_os_records/edit", type: :view do
  before(:each) do
    @legacy_os_record = assign(:legacy_os_record, LegacyOsRecord.create!(
      owner_username: "MyString",
      owner_full_name: "MyString",
      dept: "MyString",
      phone: "MyString",
      additional_dept_contact: "MyString",
      additional_dept_contact_phone: "MyString",
      support_poc: "MyString",
      legacy_os: "MyString",
      unique_app: "MyString",
      unique_hardware: "MyString",
      remediation: "MyString",
      review_contact: "MyString",
      justification: "MyString",
      local_it_support_group: "MyString",
      notes: "MyText",
      data_type: nil,
      device: nil
    ))
  end

  it "renders the edit legacy_os_record form" do
    render

    assert_select "form[action=?][method=?]", legacy_os_record_path(@legacy_os_record), "post" do

      assert_select "input[name=?]", "legacy_os_record[owner_username]"

      assert_select "input[name=?]", "legacy_os_record[owner_full_name]"

      assert_select "input[name=?]", "legacy_os_record[dept]"

      assert_select "input[name=?]", "legacy_os_record[phone]"

      assert_select "input[name=?]", "legacy_os_record[additional_dept_contact]"

      assert_select "input[name=?]", "legacy_os_record[additional_dept_contact_phone]"

      assert_select "input[name=?]", "legacy_os_record[support_poc]"

      assert_select "input[name=?]", "legacy_os_record[legacy_os]"

      assert_select "input[name=?]", "legacy_os_record[unique_app]"

      assert_select "input[name=?]", "legacy_os_record[unique_hardware]"

      assert_select "input[name=?]", "legacy_os_record[remediation]"

      assert_select "input[name=?]", "legacy_os_record[review_contact]"

      assert_select "input[name=?]", "legacy_os_record[justification]"

      assert_select "input[name=?]", "legacy_os_record[local_it_support_group]"

      assert_select "textarea[name=?]", "legacy_os_record[notes]"

      assert_select "input[name=?]", "legacy_os_record[data_type_id]"

      assert_select "input[name=?]", "legacy_os_record[device_id]"
    end
  end
end
