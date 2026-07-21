require "rails_helper"

RSpec.describe DeviceManagment do
  let(:serial) { "C02TESTSERIAL" }
  let(:hostname) { "test-hostname" }
  let(:manager) { described_class.new(serial, hostname) }

  def stub_tdx(auth_token: "fake-token", response: nil)
    allow_any_instance_of(AuthTokenApi).to receive(:get_auth_token).and_return(auth_token)
    allow_any_instance_of(DeviceTdxApi).to receive(:get_device_data).and_return(response) if response
  end

  def tdx_success_response
    {
      "result" => { "success" => true },
      "data" => {
        "serial" => serial,
        "hostname" => hostname,
        "building" => "East Hall",
        "room" => "100",
        "owner" => "Test Owner",
        "department" => "Physics",
        "manufacturer" => "Apple Inc.",
        "model" => "MacBook Pro",
        "mac" => "a4:83:e7:bb:68:5a"
      }
    }
  end

  def tdx_not_found_response
    {
      "result" => { "device_not_in_tdx" => "This device is not present in the TDX Assets database." },
      "data" => {}
    }
  end

  def tdx_too_many_response
    {
      "result" => { "more-then_one_result" => "More than one device found." },
      "data" => {}
    }
  end

  describe "#device_exist?" do
    it "returns true and sets message when serial already exists" do
      existing = FactoryBot.create(:device, serial: serial, hostname: "other-host")
      expect(manager.device_exist?).to be true
      expect(manager.device).to eq(existing)
      expect(manager.message).to include(serial)
    end

    it "returns true when hostname already exists and serial is blank" do
      existing = FactoryBot.create(:device, serial: nil, hostname: hostname)
      manager_by_host = described_class.new(nil, hostname)
      expect(manager_by_host.device_exist?).to be true
      expect(manager_by_host.device).to eq(existing)
      expect(manager_by_host.message).to include(hostname)
    end

    it "returns false when device does not exist" do
      expect(manager.device_exist?).to be false
    end
  end

  describe "#create_device" do
    it "returns early when device already exists" do
      FactoryBot.create(:device, serial: serial)
      expect(manager.create_device).to be_nil
      expect(manager.message).to include(serial)
    end

    it "builds a device from TDX data on success" do
      stub_tdx(response: tdx_success_response)
      expect(manager.create_device).to be true
      expect(manager.save_with_tdx).to be true
      expect(manager.device).to be_a(Device)
      expect(manager.device.serial).to eq(serial)
      expect(manager.device.mac).to eq("a4:83:e7:bb:68:5a")
    end

    it "builds a local device when not in TDX" do
      stub_tdx(response: tdx_not_found_response)
      expect(manager.create_device).to be true
      expect(manager.not_in_tdx).to be true
      expect(manager.device.serial).to eq(serial)
      expect(manager.device.hostname).to eq(hostname)
    end

    it "returns false when TDX reports too many results" do
      stub_tdx(response: tdx_too_many_response)
      expect(manager.create_device).to be false
      expect(manager.too_many).to be true
      expect(manager.message).to include("More than one")
    end

    it "builds a local device when auth token is unavailable" do
      stub_tdx(auth_token: false)
      expect(manager.create_device).to be true
      expect(manager.not_in_tdx).to be true
      expect(manager.message).to eq("No access to TDX API.")
      expect(manager.device.serial).to eq(serial)
    end
  end

  describe "#update_device" do
    it "returns TDX attributes on success" do
      stub_tdx(response: tdx_success_response)
      expect(manager.update_device).to be true
      expect(manager.device_attr["serial"]).to eq(serial)
      expect(manager.device_attr["mac"]).to eq("a4:83:e7:bb:68:5a")
    end

    it "returns serial/hostname attrs when device is not in TDX" do
      stub_tdx(response: tdx_not_found_response)
      expect(manager.update_device).to be true
      expect(manager.device_attr).to eq("serial" => serial, "hostname" => hostname)
    end

    it "returns false when TDX reports too many results" do
      stub_tdx(response: tdx_too_many_response)
      expect(manager.update_device).to be false
    end

    it "returns serial/hostname attrs when auth token is unavailable" do
      stub_tdx(auth_token: false)
      expect(manager.update_device).to be true
      expect(manager.message).to eq("No access to TDX API.")
      expect(manager.device_attr).to eq("serial" => serial, "hostname" => hostname)
    end
  end
end
