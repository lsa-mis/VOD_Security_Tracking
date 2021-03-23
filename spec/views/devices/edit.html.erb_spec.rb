require 'rails_helper'

RSpec.describe "devices/edit", type: :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      serial: "MyString",
      hostname: "MyString",
      mac: "MyString",
      building: "MyString",
      room: "MyString"
    ))
  end

  it "renders the edit device form" do
    render

    assert_select "form[action=?][method=?]", device_path(@device), "post" do

      assert_select "input[name=?]", "device[serial]"

      assert_select "input[name=?]", "device[hostname]"

      assert_select "input[name=?]", "device[mac]"

      assert_select "input[name=?]", "device[building]"

      assert_select "input[name=?]", "device[room]"
    end
  end
end
