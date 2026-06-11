require 'rails_helper'
require 'system/support/shared_file'

RSpec.describe "Device Controller", type: :system do
  include_context "shared functions"
  before :each do
    load "#{Rails.root}/spec/system/short_seeds.rb"
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(any_args,"mail").and_return(["test@test.com"])
    devise_ldap = double(Devise::LDAP::Adapter)
    allow(devise_ldap).to receive(:get_ldap_param).with(any_args,"memberOf").and_return(["lsa-vod-devs"])

    @me = FactoryBot.create(:user)
    login_as(@me)
    set_session(:user_memberships, devise_ldap.get_ldap_param(@me.username,'memberOf'))
    set_session(:duo_auth, true)
  end

  after :each do
    Warden.test_reset!
  end

  # Stub the TDX API so no live calls are made from these tests.
  def stub_tdx(auth_token: "fake-token", response: nil)
    allow_any_instance_of(AuthTokenApi).to receive(:get_auth_token).and_return(auth_token)
    allow_any_instance_of(DeviceTdxApi).to receive(:get_device_data).and_return(response) if response
  end

  def tdx_success_response(serial)
    {
      'result' => { 'success' => true },
      'data' => {
        'serial' => serial,
        'hostname' => 'TEST-HOSTNAME',
        'building' => 'East Hall',
        'room' => '100',
        'owner' => 'Test Owner',
        'department' => 'Physics',
        'manufacturer' => 'Apple Inc.',
        'model' => 'MacBook Pro',
        'mac' => 'a4:83:e7:bb:68:5a'
      }
    }
  end

  def tdx_not_found_response
    {
      'result' => { 'device_not_in_tdx' => 'This device is not present in the TDX Assets database.' },
      'data' => {}
    }
  end

  it 'not authorized to create a new device' do
    visit new_device_path
    expect(page).to have_content('You are not authorized to perform this action.')
  end

  it 'update a device' do
    stub_tdx(response: tdx_success_response("C02ZF95GLVDL"))

    device = Device.create(serial: "C02ZF95GLVDL")
    visit device_path(device)
    expect(page).to have_content('Click update to')
    click_on "Update"

    expect(page).to have_content('Device record was successfully updated.')
    expect(page).to have_content('a4:83:e7:bb:68:5a')
  end

  it 'update a device: device does not exist in TDX' do
    stub_tdx(response: tdx_not_found_response)

    device = Device.create(serial: "1q2w3e4r5t")
    visit device_path(device)
    click_on "Update"

    expect(page).to have_content('Device record was successfully updated.')
    expect(page).to have_content('This device is not present in the TDX Assets database.')
  end

  it 'update a device: get no auth token from AuthTokenApi class' do
    # mock false return from get_auth_token method
    stub_tdx(auth_token: false)

    device = Device.create(serial: "1q2w3e4r5t")
    visit device_path(device)
    click_on "Update"

    expect(page).to have_content('No access to TDX API.')
  end

end
