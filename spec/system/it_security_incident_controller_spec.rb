require 'rails_helper'
require 'system/support/shared_file'

RSpec.describe "ItSecurityIncident Controller", type: :system do
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

    visit new_it_security_incident_path
    fill_in 'Title', with: 'Title'
    fill_in_date_with_js_by_id('it_security_incident_date', with: '2021-09-20')
    fill_in_trix_editor('it_security_incident_people_involved_trix_input_it_security_incident', with: 'People involved')
    fill_in_trix_editor('it_security_incident_equipment_involved_trix_input_it_security_incident', with: 'Equipment involved')
    fill_in_trix_editor('it_security_incident_remediation_steps_trix_input_it_security_incident', with: 'Remediation steps')
    select 'ITAR', from: 'Data type'
    select 'Open', from: 'IT security incident status'
    click_on 'Create'

    expect(page).to have_content('IT Security Incident record was successfully created.')
    expect(page).to have_content('Record Saved, but not complete.')
    expect(ItSecurityIncident.last.incomplete).to be(true)
  end

  it 'create record with all fields' do

    visit new_it_security_incident_path
    fill_in 'Title', with: 'Title'
    fill_in_date_with_js_by_id('it_security_incident_date', with: '2021-09-20')
    fill_in_trix_editor('it_security_incident_people_involved_trix_input_it_security_incident', with: 'People involved')
    fill_in_trix_editor('it_security_incident_equipment_involved_trix_input_it_security_incident', with: 'Equipment involved')
    fill_in_trix_editor('it_security_incident_remediation_steps_trix_input_it_security_incident', with: 'Remediation steps')
    select 'ITAR', from: 'Data type'
    select 'Open', from: 'IT security incident status'
    fill_in 'Estimated financial cost', with: '400.00'
    fill_in_trix_editor('it_security_incident_notes_trix_input_it_security_incident', with: 'Some notes')

    click_on 'Create'

    expect(page).to have_content('IT Security Incident record was successfully created.')
    expect(page).to_not have_content('Record Saved, but not complete.')
    expect(ItSecurityIncident.last.incomplete).to be(false)

  end

end
