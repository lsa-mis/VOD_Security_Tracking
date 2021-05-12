require 'rails_helper'

RSpec.describe "Device Controller", type: :system do
    before do
        @me = FactoryBot.create(:user)
        login_as(@me)
    end

    scenario 'devise does not exist in TDX' do
        visit new_device_path
        fill_in 'Serial', with: "1q2w3e4r5t"
        click_on 'Create Device'
        sleep(inspection_time=5)

        expect(page).to have_content('device was successfully created. This device is not present in the TDX Assets database')
    end

    scenario 'device already exists in the table' do
        device = FactoryBot.create(:device, {serial: "1q2w3e4r5t"})
        visit new_device_path
        fill_in 'Serial', with: "1q2w3e4r5t"
        click_on 'Create Device'
        sleep(inspection_time=5)

        expect(page).to have_content('The device with serial number [1q2w3e4r5t] already exist')
    end

    scenario 'get device from TDX' do
        visit new_device_path
        fill_in 'Serial', with: "C02ZF95GLVDL"
        click_on 'Create Device'
        sleep(inspection_time=5)

        expect(page).to have_content('device was successfully created.')
    end

    scenario 'get many results from TDX API' do
        visit new_device_path
        fill_in 'Hostname', with: "nick"
        click_on 'Create Device'
        sleep(inspection_time=5)

        expect(page).to have_content('More then one result returned for serial or hostname [nick]')
    end

    scenario 'get no auth token from AuthTokenApi class' do
        # mock false return from get_auth_token method
        allow_any_instance_of(AuthTokenApi).to receive(:get_auth_token).and_return(false)

        visit new_device_path
        fill_in 'Hostname', with: "nick"
        click_on 'Create Device'
        sleep(inspection_time=5)

        expect(page).to have_content('No access to TDX API')
    end
end