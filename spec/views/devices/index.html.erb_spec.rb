require 'rails_helper'

RSpec.describe "devices/index", type: :view do
  before(:each) do
    assign(:devices, [
      Device.create!(
        serial: "Serial",
        hostname: "Hostname",
        mac: "Mac",
        building: "Building",
        room: "Room"
      ),
      Device.create!(
        serial: "Serial",
        hostname: "Hostname",
        mac: "Mac",
        building: "Building",
        room: "Room"
      )
    ])
  end

  it "renders a list of devices" do
    render
    assert_select "tr>td", text: "Serial".to_s, count: 2
    assert_select "tr>td", text: "Hostname".to_s, count: 2
    assert_select "tr>td", text: "Mac".to_s, count: 2
    assert_select "tr>td", text: "Building".to_s, count: 2
    assert_select "tr>td", text: "Room".to_s, count: 2
  end
end
