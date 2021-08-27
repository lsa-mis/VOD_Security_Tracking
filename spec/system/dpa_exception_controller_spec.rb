# correct version of chromedriver should be installed
# update chromedriver from here: https://chromedriver.chromium.org/downloads
require 'rails_helper'
require 'system/support/shared_file'

RSpec.describe "DpaException Controller", type: :system do
  include_context "before and after methods for controller tests"

  scenario 'create record with requered fields' do

    visit new_dpa_exception_path
    puts @ldap_groups
    # fill_in_date_with_js('Review date exception first approval date', with: '2021-09-20')
    fill_in_date_with_js_by_id('dpa_exception_review_date_exception_first_approval_date', with: '2021-09-20')
    select 'Approved', from: 'Status'
    fill_in 'Third party product service', with: 'Third party product service'
    select 'Physics', from: 'Department'
    click_on 'Create'
    # sleep(inspection_time=3)

    expect(page).to have_content('DPA Exception record was successfully created.')
    expect(page).to have_content('Record Saved, but not complete.')

  end

end