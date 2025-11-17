require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#show_department_name" do
    it "returns department display name" do
      department = FactoryBot.create(:department, name: "Test Dept")
      resource = double(department: department)
      expect(helper.show_department_name(resource)).to eq("Test Dept")
    end
  end

  describe "#show_data_type_name" do
    it "returns data type display name when present" do
      data_type = FactoryBot.create(:data_type)
      resource = double(data_type: data_type)
      expect(helper.show_data_type_name(resource)).to include(data_type.name)
    end

    it "returns default message when data type is nil" do
      resource = double(data_type: nil)
      expect(helper.show_data_type_name(resource)).to eq("No data type has been selected")
    end
  end

  describe "#show_it_security_incident_status" do
    it "returns status name when present" do
      status = FactoryBot.create(:it_security_incident_status, name: "Active")
      resource = double(it_security_incident_status: status)
      expect(helper.show_it_security_incident_status(resource)).to eq("Active")
    end

    it "returns default message when status is nil" do
      resource = double(it_security_incident_status: nil)
      expect(helper.show_it_security_incident_status(resource)).to eq("No status has been selected")
    end
  end

  describe "#show_dpa_exception_status" do
    it "returns status name when present" do
      status = FactoryBot.create(:dpa_exception_status)
      resource = double(dpa_exception_status: status)
      expect(helper.show_dpa_exception_status(resource)).to eq(status.name)
    end

    it "returns default message when status is nil" do
      resource = double(dpa_exception_status: nil)
      expect(helper.show_dpa_exception_status(resource)).to eq("No status has been selected")
    end
  end

  describe "#show_device" do
    it "returns device display name when present" do
      device = FactoryBot.create(:device, hostname: "HOST1")
      resource = double(device: device)
      expect(helper.show_device(resource)).to eq("HOST1")
    end

    it "returns 'none' when device is nil" do
      resource = double(device: nil)
      expect(helper.show_device(resource)).to eq("none")
    end
  end

  describe "#show_device_hostname" do
    it "returns device hostname when present" do
      device = FactoryBot.create(:device, hostname: "HOST1")
      resource = double(device: device)
      expect(helper.show_device_hostname(resource)).to eq("HOST1")
    end

    it "returns 'none' when device is nil" do
      resource = double(device: nil)
      expect(helper.show_device_hostname(resource)).to eq("none")
    end
  end

  describe "#show_device_serial" do
    it "returns device serial when present" do
      device = FactoryBot.create(:device, serial: "S123")
      resource = double(device: device)
      expect(helper.show_device_serial(resource)).to eq("S123")
    end

    it "returns 'none' when device is nil" do
      resource = double(device: nil)
      expect(helper.show_device_serial(resource)).to eq("none")
    end
  end

  describe "#show_storage_location" do
    it "returns storage location display name when present" do
      storage_location = FactoryBot.create(:storage_location)
      resource = double(storage_location: storage_location)
      expect(helper.show_storage_location(resource)).to eq(storage_location.name)
    end

    it "returns default message when storage location is nil" do
      resource = double(storage_location: nil)
      expect(helper.show_storage_location(resource)).to eq("No storage location has been selected")
    end
  end

  describe "#show_date" do
    it "formats date correctly" do
      date = Date.new(2024, 3, 15)
      expect(helper.show_date(date)).to eq("03/15/2024")
    end

    it "returns nil for blank date" do
      expect(helper.show_date(nil)).to be_nil
      expect(helper.show_date("")).to be_nil
    end
  end

  describe "#user_name_email" do
    it "returns user display name" do
      allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@example.com"])
      user = FactoryBot.create(:user, username: "testuser", email: "test@example.com")
      expect(helper.user_name_email(user.id)).to eq("testuser - test@example.com")
    end
  end

  describe "#note_types" do
    it "returns array of note types" do
      expect(helper.note_types).to eq([['Alert','alert'], ['Notice','notice']])
    end
  end
end
