require 'rails_helper'
require 'system/support/shared_file'

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
    Warden.test_reset!
  end

  it 'create record with requered fields' do

    visit new_dpa_exception_path
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_first_approval_date', with: '2021-09-20')
    select 'Approved', from: 'Status'
    fill_in 'Third party product service', with: 'Third party product service'
    select 'Physics', from: 'Department'
    click_on 'Create'

    expect(page).to have_content('DSA Exception record was successfully created.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(DpaException.last.incomplete).to be(true)
  end

  it 'create record with all fields' do

    visit new_dpa_exception_path
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_first_approval_date', with: '2021-09-20')
    select 'Approved', from: 'Status'
    fill_in 'Third party product service', with: 'Third party product service'
    select 'Physics', from: 'Department'
    fill_in 'Point of contact', with: 'Point of contact'
    fill_in_trix_editor('dpa_exception_review_findings_trix_input_dpa_exception', with: 'Review findings')
    fill_in_trix_editor('dpa_exception_review_summary_trix_input_dpa_exception', with: 'Review summary')
    fill_in_trix_editor('dpa_exception_lsa_security_recommendation_trix_input_dpa_exception', with: 'LSA security recommendation')
    fill_in_trix_editor('dpa_exception_lsa_security_determination_trix_input_dpa_exception', with: 'LSA security determination')
    fill_in 'LSA security approval', with: 'LSA security approval'
    fill_in 'LSA technology services approval', with: 'LSA technology services approval'
    fill_in_date_with_js_by_id('dpa_exception_exception_approval_date_exception_renewal_date_due', with: '2021-09-20')
    # The review date must be after the first approval date.
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_review_date', with: '2021-10-20')
    select 'EAR', from: 'Data type'
    click_on 'Create'

    expect(page).to have_content('DSA Exception record was successfully created.')
    expect(page).to_not have_content('Record Saved, but not complete.')
    expect(DpaException.last.incomplete).to be(false)
  end

end
