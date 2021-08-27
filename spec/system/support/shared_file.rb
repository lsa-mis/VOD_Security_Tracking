shared_context "before and after methods for controller tests" do
  before do

    def set_session(key, value)
      Warden.on_next_request do |proxy|
        proxy.raw_session[key] = value
      end
    end

    # https://github.com/kristians-kuhta/flatpickr-testing/blob/master/spec/features/user_fills_in_date_spec.rb

    #  is not working with "Unable to find css ".flatpickr-input" that is a sibling of visible label" error
    # def fill_in_date_with_js(label_text, with:)
    #   date_field = find(:label, text: label_text).sibling('.flatpickr-input', visible: false)
    #   script = "document.querySelector('##{date_field[:id]}').flatpickr().setDate('#{with}');"
    #   page.execute_script(script)
    # end

    def fill_in_date_with_js_by_id(id, with:)
      script = "document.querySelector('##{id}').flatpickr().setDate('#{with}');"
      page.execute_script(script)
    end

    load "#{Rails.root}/spec/system/test_seeds.rb" 

    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(any_args,"mail").and_return(["test@test.com"])
    devise_ldap = double(Devise::LDAP::Adapter)
    allow(devise_ldap).to receive(:get_ldap_param).with(any_args,"memberOf").and_return(["lsa-vod-devs"])
    # skip duo
    DpaExceptionsController.new.class.skip_before_action :verify_duo_authentication

    @me = FactoryBot.create(:user)
    login_as(@me)
    set_session(:user_memberships, devise_ldap.get_ldap_param(@me.username,'memberOf'))

  end

  after do
    # Log out is not working
    # visit root_path
    # click_link 'Log Out', visible: false
    Capybara::Session#reset!
  end

end
  