require 'rails_helper'

RSpec.describe "Devices", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ['test-group']
    u
  end
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: 'devices', ldap_group: 'test-group') }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ['test-group'])
  end

  describe "GET /devices" do
    it "returns success for authorized user" do
      access_lookup
      get devices_path
      expect(response).to have_http_status(:success)
    end

    it "redirects unauthorized user" do
      user.membership = []
      get devices_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /devices/:id" do
    let(:device) { FactoryBot.create(:device) }

    it "shows the device" do
      access_lookup
      get device_path(device)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /devices/new" do
    it "redirects unauthorized user" do
      access_lookup
      get new_device_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /devices/:id/edit" do
    let(:device) { FactoryBot.create(:device) }

    it "shows edit form for authorized user" do
      FactoryBot.create(:access_lookup, vod_table: 'devices', vod_action: 'newedit', ldap_group: 'test-group')
      get edit_device_path(device)
      expect(response).to have_http_status(:success)
    end

    it "redirects unauthorized user" do
      get edit_device_path(device)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /devices/:id" do
    let(:device) { FactoryBot.create(:device) }

    before do
      allow_any_instance_of(DeviceManagment).to receive(:update_device).and_return(true)
      allow_any_instance_of(DeviceManagment).to receive(:device_attr).and_return({})
      allow_any_instance_of(DeviceManagment).to receive(:message).and_return("")
    end

    it "updates the device for authorized user" do
      FactoryBot.create(:access_lookup, vod_table: 'devices', vod_action: 'newedit', ldap_group: 'test-group')
      patch device_path(device), params: {
        device: {
          serial: device.serial,
          hostname: device.hostname
        }
      }
      expect(response).to redirect_to(device_path(device))
    end
  end
end
