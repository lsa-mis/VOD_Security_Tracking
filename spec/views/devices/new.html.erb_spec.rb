require 'rails_helper'

RSpec.describe "devices/new", type: :view do
  before(:each) do
    assign(:device, Device.new(
      serial: "MyString",
      hostname: "MyString",
      mac: "MyString",
      building: "MyString",
      room: "MyString"
    ))
  end

  it "renders new device form" do
    render

    assert_select "form[action=?][method=?]", devices_path, "post" do

      assert_select "input[name=?]", "device[serial]"

      assert_select "input[name=?]", "device[hostname]"

      assert_select "input[name=?]", "device[mac]"

      assert_select "input[name=?]", "device[building]"

      assert_select "input[name=?]", "device[room]"
    end
  end
end
