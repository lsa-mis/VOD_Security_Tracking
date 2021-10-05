# correct version of chromedriver should be installed
# update chromedriver from here: https://chromedriver.chromium.org/downloads
require 'rails_helper'
require 'system/support/shared_file'
# require 'system/support/before_and_after_tests'

RSpec.describe "DpaException Controller", type: :system do
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

  it 'create record with requered fields' do

    visit new_dpa_exception_path
    # fill_in_date_with_js('Review date exception first approval date', with: '2021-09-20')
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_first_approval_date', with: '2021-09-20')
    select 'Approved', from: 'Status'
    fill_in 'Third party product service', with: 'Third party product service'
    select 'Physics', from: 'Department'
    click_on 'Create'
    sleep(inspection_time=3)

    expect(page).to have_content('DPA Exception record was successfully created.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(DpaException.last.incomplete).to be(true)
    DpaException.last.destroy
  end

  it 'create record with all fields' do

    visit new_dpa_exception_path
    # fill_in_date_with_js('Review date exception first approval date', with: '2021-09-20')
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_first_approval_date', with: '2021-09-20')
    select 'Approved', from: 'Status'
    fill_in 'Third party product service', with: 'Third party product service'
    select 'Physics', from: 'Department'
    fill_in 'Point of contact', with: 'Point of contact'
    find(:xpath, "//\*[@input='dpa_exception_review_findings_trix_input_dpa_exception']").set('Review findings')
    find(:xpath, "//\*[@input='dpa_exception_review_summary_trix_input_dpa_exception']").set('Review summary')
    find(:xpath, "//\*[@input='dpa_exception_lsa_security_recommendation_trix_input_dpa_exception']").set('LSA security recommendation')
    find(:xpath, "//\*[@input='dpa_exception_lsa_security_determination_trix_input_dpa_exception']").set('LSA security determination')
    fill_in 'LSA security approval', with: 'LSA security approval'
    fill_in 'LSA technology services approval', with: 'LSA technology services approval'
    fill_in_date_with_js_by_id('dpa_exception_exception_approval_date_exception_renewal_date_due', with: '2021-09-20')
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_review_date', with: '2021-09-20')
    select 'EAR', from: 'Data type'
    click_on 'Create'
    sleep(inspection_time=3)

    expect(page).to have_content('DPA Exception record was successfully created.')
    expect(page).to_not have_content('Record Saved, but not complete.')
    expect(DpaException.last.incomplete).to be(false)
    DpaException.last.destroy
  end

  # it 'test browser validation for requered fields' do
  #   visit new_dpa_exception_path
  #   click_on 'Create'
  #   expect(page).to have_content('Please select an item in the list.')
  # end

end