require 'rails_helper'
require 'system/support/shared_file'

RSpec.describe "Device Controller", type: :system do
  include_context "shared functions"
  before :each do
    # @me = FactoryBot.create(:user)
    # login_as(@me)
    load "#{Rails.root}/spec/system/short_seeds.rb"
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(any_args,"mail").and_return(["test@test.com"])
    devise_ldap = double(Devise::LDAP::Adapter)
    allow(devise_ldap).to receive(:get_ldap_param).with(any_args,"memberOf").and_return(["lsa-vod-devs"])
    # skip duo
    DevicesController.new.class.skip_before_action :verify_duo_authentication

    @me = FactoryBot.create(:user)
    login_as(@me)
    set_session(:user_memberships, devise_ldap.get_ldap_param(@me.username,'memberOf'))

  end

  after :each do
    # Log out is not working
    # visit root_path
    # click_link 'Log Out', visible: false
    Capybara::Session#reset!
  end

  it 'not authorized to create a new device' do
    visit new_device_path
    expect(page).to have_content('You are not authorized to perform this action.')
  end

  # it 'update a device' do
  #   device = Device.create(serial: "C02ZF95GLVDL")
  #   visit device_path(device)
  #   expect(page).to have_content('Click update to')
  #   click_on "Update"
  #   sleep(inspection_time=5)
  #   expect(page).to have_content('Device record was successfully updated.')
  #   expect(page).to have_content('a4:83:e7:bb:68:5a')
  # end

  # it 'update a device: devise does not exist in TDX' do
  #   device = Device.create(serial: "1q2w3e4r5t")
  #   visit device_path(device)
  #   click_on "Update"
  #   sleep(inspection_time=5)
  #   expect(page).to have_content('Device record was successfully updated.This device is not present in the TDX Assets database.')
  # end

  # scenario 'update a device: get no auth token from AuthTokenApi class' do
  #   # mock false return from get_auth_token method
  #   allow_any_instance_of(AuthTokenApi).to receive(:get_auth_token).and_return(false)

  #   device = Device.create(serial: "1q2w3e4r5t")
  #   visit device_path(device)
  #   click_on "Update"
  #   sleep(inspection_time=5)
  #   expect(page).to have_content('No access to TDX API.')
  # end

end