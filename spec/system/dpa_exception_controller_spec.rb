# correct version of chromedriver should be installed
# update chromedriver from here: https://chromedriver.chromium.org/downloads
require 'rails_helper'

RSpec.describe "DpaException Controller", type: :system do

  before do

    def _set_session(key, value)
      Warden.on_next_request do |proxy|
        proxy.raw_session[key] = value
      end
    end
    

    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(any_args,"mail").and_return(["test@test.com"])

    devise_ldap = double(Devise::LDAP::Adapter)

    allow(devise_ldap).to receive(:get_ldap_param).with(any_args,"memberOf").and_return(["lsa-vod-devs"])

    # skip duo
    DpaExceptionsController.new.class.skip_before_action :verify_duo_authentication

    @me = FactoryBot.create(:user)
    login_as(@me)
    _set_session(:user_memberships, devise_ldap.get_ldap_param(@me.username,'memberOf'))
    @me.membership = devise_ldap.get_ldap_param(@me.username,'memberOf')
    @me.dept_membership = []
    Rails.logger.debug "****** @me.username #{@me.username}"

    Rails.logger.debug "****** @me.membership #{@me.membership}"
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@me)

    @home_text = Infotext.new(location: "home")
    @home_text.content = "home"
    @home_text.save
    @dpa_exception_index_text =  Infotext.new(location: "dpa_exception_index")
    AccessLookup.create([
    {ldap_group: 'lsa-vod-devs', vod_table: 'dpa_exceptions', vod_action: 'all'}
  ])
  end

  scenario 'create record with requered fields' do

    Rails.logger.debug "****** in test @me.membership #{@me.membership}"

    visit new_dpa_exception_path
    puts @ldap_groups
    sleep(inspection_time=8)
    fill_in 'Review date exception first approval date', with: Faker::Date.in_date_period
    select '1', from: 'dpa_exception_status_id'
    fill_in 'Third party product service', with: 'Third party product service'
    select '22', from:  'department_id'
    click_on 'Create'
    sleep(inspection_time=8)

    expect(page).to have_content('DPA Exception record was successfully created.')
  end

end