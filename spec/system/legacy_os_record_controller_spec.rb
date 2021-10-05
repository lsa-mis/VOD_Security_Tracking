# correct version of chromedriver should be installed
# update chromedriver from here: https://chromedriver.chromium.org/downloads
require 'rails_helper'
require 'system/support/shared_file'
# require 'system/support/before_and_after_tests'

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
    # Log out is not working
    # visit root_path
    # click_link 'Log Out', visible: false
    Capybara::Session#reset!
  end

  it 'create record with requered fields and device (which is in the TDX assets database)' do

    visit new_legacy_os_record_path
    fill_in 'Owner username', with: 'brita'
    fill_in 'Owner full name', with: 'Margarita Barvinok'
    select 'Physics', from: 'Department'
    fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
    fill_in 'Unique app', with: 'Unique app'
    fill_in 'legacy_os_record_device_attributes_serial', with: 'C02ZF95GLVDL'

    click_on 'Submit'
    sleep(inspection_time=3)

    expect(page).to have_content('Legacy OS record was successfully created.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(LegacyOsRecord.last.incomplete).to be(true)
    LegacyOsRecord.last.destroy
  end

  it 'create record with requered fields with device device that is not present in the TDX Assets database' do

    visit new_legacy_os_record_path
    fill_in 'Owner username', with: 'brita'
    fill_in 'Owner full name', with: 'Margarita Barvinok'
    select 'Physics', from: 'Department'
    fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
    fill_in 'Unique app', with: 'Unique app'
    fill_in 'legacy_os_record_device_attributes_serial', with: '12345ertyuhgfda'

    click_on 'Submit'
    sleep(inspection_time=3)

    expect(page).to have_content('Legacy OS record was successfully created.')
    expect(page).to have_content('This device is not present in the TDX Assets database.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(LegacyOsRecord.last.incomplete).to be(true)
    LegacyOsRecord.last.destroy
  end

  it 'create record with requered fields with device with a serial that returned more then one result from the TDX assets database search' do

    visit new_legacy_os_record_path
    fill_in 'Owner username', with: 'brita'
    fill_in 'Owner full name', with: 'Margarita Barvinok'
    select 'Physics', from: 'Department'
    fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
    fill_in 'Unique app', with: 'Unique app'
    fill_in 'legacy_os_record_device_attributes_serial', with: 'Serial'

    click_on 'Submit'
    sleep(inspection_time=3)

    expect(page).to have_content('More than one result returned for serial or hostname')

  end

  # it 'create record with all fields' do

  #   visit new_it_security_incident_path
  #   fill_in 'Owner username', with: 'brita'
  #   fill_in 'Owner full name', with: 'Margarita Barvinok'
  #   select 'Physics', from: 'Department'
  #   fill_in 'Phone', :with => Faker::PhoneNumber.phone_number
  #   fill_in 'Additional department contact', with: 'rsmoke'
  #   fill_in 'Additional department contact phone', :with => Faker::PhoneNumber.phone_number
  #   fill_in 'Support poc', with: 'Support poc'
  #   fill_in 'Legacy OS', with: 'Windows XP'
  #   fill_in 'Unique app', with: 'Unique app'
  #   fill_in_date_with_js_by_id('legacy_os_record_unique_date', with: '2021-09-20')
  #   find(:xpath, "//\*[@input='legacy_os_record_remediation_trix_input_legacy_os_record']").set('Remediation')
  #   fill_in_date_with_js_by_id('legacy_os_record_exception_approval_date', with: '2021-09-20')
  #   fill_in_date_with_js_by_id('legacy_os_record_review_date', with: '2021-09-20')
  #   fill_in 'Review contact', with: 'brita'
  #   find(:xpath, "//\*[@input='legacy_os_record_justification_trix_input_legacy_os_record']").set('Justification')
  #   fill_in 'Local IT support group', with: 'East Hall'
  #   select 'ITAR', from: 'Data type'
  #   fill_in 'legacy_os_record_device_attributes_serial', with: 'Serial'

  #   click_on 'Submit'
  #   sleep(inspection_time=3)

  #   expect(page).to have_content('Legacy OS record was successfully created.')
  #   expect(page).to_not have_content('Record Saved, but not complete.')
  #   expect(LegacyOsRecord.last.incomplete).to be(false)

  #   LegacyOsRecord.last.destroy

  # end

end