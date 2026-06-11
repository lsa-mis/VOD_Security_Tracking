require 'rails_helper'
require 'system/support/shared_file'

RSpec.describe "LegacyOsRecord Controller", type: :system do
  include_context "shared functions"
  before :each do

    load "#{Rails.root}/spec/system/test_seeds.rb"

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
  def stub_tdx(response)
    allow_any_instance_of(AuthTokenApi).to receive(:get_auth_token).and_return("fake-token")
    allow_any_instance_of(DeviceTdxApi).to receive(:get_device_data).and_return(response)
  end

  it 'create record with requered fields and device (which is in the TDX assets database)' do
    stub_tdx(
      'result' => { 'success' => true },
      'data' => {
        'serial' => 'C02ZF95GLVDL',
        'hostname' => 'TEST-HOSTNAME',
        'building' => 'East Hall',
        'room' => '100',
        'owner' => 'Test Owner',
        'department' => 'Physics',
        'manufacturer' => 'Apple Inc.',
        'model' => 'MacBook Pro',
        'mac' => 'a4:83:e7:bb:68:5a'
      }
    )

    visit new_legacy_os_record_path
    fill_in 'Owner username', with: 'brita'
    fill_in 'Owner full name', with: 'Margarita Barvinok'
    select 'Physics', from: 'Department'
    fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
    fill_in 'Unique app', with: 'Unique app'
    fill_in 'legacy_os_record_device_attributes_serial', with: 'C02ZF95GLVDL'

    click_on 'Submit'

    expect(page).to have_content('Legacy OS record was successfully created.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(LegacyOsRecord.last.incomplete).to be(true)
  end

  it 'create record with requered fields with device device that is not present in the TDX Assets database' do
    stub_tdx(
      'result' => { 'device_not_in_tdx' => 'This device is not present in the TDX Assets database.' },
      'data' => {}
    )

    visit new_legacy_os_record_path
    fill_in 'Owner username', with: 'brita'
    fill_in 'Owner full name', with: 'Margarita Barvinok'
    select 'Physics', from: 'Department'
    fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
    fill_in 'Unique app', with: 'Unique app'
    fill_in 'legacy_os_record_device_attributes_serial', with: '12345ertyuhgfda'

    click_on 'Submit'

    expect(page).to have_content('Legacy OS record was successfully created.')
    expect(page).to have_content('This device is not present in the TDX Assets database.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(LegacyOsRecord.last.incomplete).to be(true)
  end

  it 'create record with requered fields with device with a serial that returned more then one result from the TDX assets database search' do
    stub_tdx(
      'result' => { 'more-then_one_result' => 'More than one result returned for serial or hostname [Serial].' },
      'data' => {}
    )

    visit new_legacy_os_record_path
    fill_in 'Owner username', with: 'brita'
    fill_in 'Owner full name', with: 'Margarita Barvinok'
    select 'Physics', from: 'Department'
    fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
    fill_in 'Unique app', with: 'Unique app'
    fill_in 'legacy_os_record_device_attributes_serial', with: 'Serial'

    click_on 'Submit'

    expect(page).to have_content('More than one result returned for serial or hostname')

  end

end
