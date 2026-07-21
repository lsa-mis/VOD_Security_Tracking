require "rails_helper"
require "rake"

RSpec.describe "devicinator rake task" do
  before(:all) do
    Rails.application.load_tasks
  end

  before do
    Rake::Task["devicinator"].reenable
  end

  def stub_tdx_update(attrs)
    manager = instance_double(DeviceManagment, update_device: true, device_attr: attrs)
    allow(DeviceManagment).to receive(:new).and_return(manager)
  end

  it "updates devices from TDX attributes" do
    device = FactoryBot.create(:device, serial: "SERIAL1", hostname: "old-host", mac: nil)
    stub_tdx_update("serial" => "SERIAL1", "hostname" => "new-host", "mac" => "aa:bb:cc:dd:ee:ff")

    expect {
      Rake::Task["devicinator"].invoke
    }.to output(/The device update ran/).to_stdout

    device.reload
    expect(device.hostname).to eq("new-host")
    expect(device.mac).to eq("aa:bb:cc:dd:ee:ff")
  end

  it "continues when a single device update fails" do
    good = FactoryBot.create(:device, serial: "GOOD", hostname: "good-host")
    bad = FactoryBot.create(:device, serial: "BAD", hostname: "bad-host")

    good_manager = instance_double(DeviceManagment, update_device: true, device_attr: { "hostname" => "updated-good" })
    bad_manager = instance_double(DeviceManagment)
    allow(bad_manager).to receive(:update_device).and_raise(StandardError, "TDX boom")

    allow(DeviceManagment).to receive(:new) do |serial, _hostname|
      serial == "BAD" ? bad_manager : good_manager
    end

    expect {
      Rake::Task["devicinator"].invoke
    }.to output(/Failed to update device #{bad.id}/).to_stdout

    expect(good.reload.hostname).to eq("updated-good")
    expect(bad.reload.hostname).to eq("bad-host")
  end
end
