# == Schema Information
#
# Table name: devices
#
#  id           :bigint           not null, primary key
#  serial       :string(255)
#  hostname     :string(255)
#  mac          :string(255)
#  building     :string(255)
#  room         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner        :string(255)
#  department   :string(255)
#  manufacturer :string(255)
#  model        :string(255)
#
require 'rails_helper'

RSpec.describe Device, type: :model do
  describe "validations" do
    it "is valid with serial and/or hostname attributes" do
      device = FactoryBot.create(:device)
      expect(device).to be_valid
      device.destroy
      expect(Device.new(serial: "serial")).to be_valid
      expect(Device.new(hostname: "hostname")).to be_valid
    end

    it "requires serial or hostname" do
      device = Device.new
      expect(device).not_to be_valid
      expect(device.errors[:serial]).to be_present
    end

    it "validates uniqueness of serial" do
      FactoryBot.create(:device, serial: "ABC123")
      device = Device.new(serial: "ABC123")
      expect(device).not_to be_valid
    end

    it "validates uniqueness of hostname" do
      FactoryBot.create(:device, hostname: "host1")
      device = Device.new(hostname: "host1")
      expect(device).not_to be_valid
    end

    it "allows blank serial if hostname is present" do
      device = Device.new(hostname: "hostname")
      expect(device).to be_valid
    end

    it "allows blank hostname if serial is present" do
      device = Device.new(serial: "serial")
      expect(device).to be_valid
    end
  end

  describe "associations" do
    let(:device) { FactoryBot.create(:device) }
    let(:sensitive_data_system) { FactoryBot.create(:sensitive_data_system, device: device) }
    let(:legacy_os_record) { FactoryBot.create(:legacy_os_record, device: device) }

    it "has many sensitive_data_systems" do
      expect(device.sensitive_data_systems).to include(sensitive_data_system)
    end

    it "has many legacy_os_records" do
      expect(device.legacy_os_records).to include(legacy_os_record)
    end

    it "has many audits" do
      expect(device).to respond_to(:audits)
    end
  end

  describe "callbacks" do
    it "prevents destruction if referenced by legacy_os_records" do
      device = FactoryBot.create(:device)
      FactoryBot.create(:legacy_os_record, device: device)

      expect { device.destroy }.not_to change { Device.count }
      expect(device.errors[:base]).to include("Can't destroy this device")
    end

    it "prevents destruction if referenced by sensitive_data_systems" do
      device = FactoryBot.create(:device)
      FactoryBot.create(:sensitive_data_system, device: device)

      expect { device.destroy }.not_to change { Device.count }
      expect(device.errors[:base]).to include("Can't destroy this device")
    end

    it "allows destruction if not referenced" do
      device = FactoryBot.create(:device)
      expect { device.destroy }.to change { Device.count }.by(-1)
    end
  end

  describe "scopes" do
    describe ".incomplete" do
      it "returns devices missing required fields" do
        incomplete1 = FactoryBot.create(:device, serial: "", mac: "", owner: "")
        incomplete2 = FactoryBot.create(:device, hostname: "", mac: "", owner: "")
        complete = FactoryBot.create(:device, serial: "S123", mac: "AA:BB:CC", owner: "John")

        incomplete_devices = Device.incomplete
        expect(incomplete_devices).to include(incomplete1, incomplete2)
        expect(incomplete_devices).not_to include(complete)
      end
    end
  end

  describe "#complete?" do
    it "returns false when missing required fields" do
      device = Device.new(serial: "S123")
      expect(device.complete?).to be false
    end

    it "returns true when all required fields are present" do
      device = FactoryBot.create(:device, serial: "S123", mac: "AA:BB:CC", owner: "John")
      expect(device.complete?).to be true
    end

    it "returns true with hostname instead of serial" do
      device = FactoryBot.create(:device, hostname: "HOST1", mac: "AA:BB:CC", owner: "John")
      expect(device.complete?).to be true
    end
  end

  describe "#display_name" do
    it "returns hostname if present" do
      device = FactoryBot.create(:device, hostname: "HOST1", serial: "S123")
      expect(device.display_name).to eq("HOST1")
    end

    it "returns serial if hostname is blank" do
      device = FactoryBot.create(:device, serial: "S123", hostname: "")
      expect(device.display_name).to eq("S123")
    end
  end

  describe "#display_hostname_serial" do
    it "returns formatted hostname and serial" do
      device = FactoryBot.create(:device, hostname: "HOST1", serial: "S123")
      result = device.display_hostname_serial
      expect(result).to include("Hostname: HOST1")
      expect(result).to include("Serial: S123")
    end

    it "handles missing hostname" do
      device = FactoryBot.create(:device, serial: "S123", hostname: "")
      result = device.display_hostname_serial
      expect(result).to include("Hostname: none")
      expect(result).to include("Serial: S123")
    end

    it "handles missing serial" do
      device = FactoryBot.create(:device, hostname: "HOST1", serial: "")
      result = device.display_hostname_serial
      expect(result).to include("Hostname: HOST1")
      expect(result).to include("Serial: none")
    end
  end

  describe "#display_hostname" do
    it "returns hostname" do
      device = FactoryBot.create(:device, hostname: "HOST1")
      expect(device.display_hostname).to eq("HOST1")
    end
  end

  describe "#display_serial" do
    it "returns serial" do
      device = FactoryBot.create(:device, serial: "S123")
      expect(device.display_serial).to eq("S123")
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(Device.ransackable_attributes).to be_an(Array)
      expect(Device.ransackable_attributes).to include("serial", "hostname", "mac", "owner")
    end
  end

  describe ".ransackable_associations" do
    it "returns an array of searchable associations" do
      expect(Device.ransackable_associations).to be_an(Array)
      expect(Device.ransackable_associations).to include("legacy_os_records", "sensitive_data_systems")
    end
  end
end
