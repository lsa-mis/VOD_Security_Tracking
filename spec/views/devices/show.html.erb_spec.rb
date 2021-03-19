require 'rails_helper'

RSpec.describe "devices/show", type: :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      serial: "Serial",
      hostname: "Hostname",
      mac: "Mac",
      building: "Building",
      room: "Room"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Serial/)
    expect(rendered).to match(/Hostname/)
    expect(rendered).to match(/Mac/)
    expect(rendered).to match(/Building/)
    expect(rendered).to match(/Room/)
  end
end
