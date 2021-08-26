require "rails_helper"

RSpec.describe "Signing in", type: :system do
  # let!(:user) { FactoryBot.create(:user) }

  before :all do
    @port = 3389

    @domain                 = "dc=test,dc=com"
    @toplevel_user_dn       = "cn=admin_user,cn=TOPLEVEL,#{@domain}"
    @toplevel_user_password = "admin_password"

    @regular_user_cn        = "regular_user"
    @regular_user_dn        = "cn=#{@regular_user_cn},ou=USERS,#{@domain}"
    @regular_user_password  = "regular_password"
    @regular_user_email     = "#{@regular_user_cn}@test.com"
    

    @server = FakeLDAP::Server.new(:port => @port)
    @server.run_tcpserver
    Rails.logger.debug "*****start server"
    @server.add_user(@toplevel_user_dn, @toplevel_user_password)
    @server.add_user(@regular_user_dn, @regular_user_password, @regular_user_email)

    # @group_ou = "ou=GROUPS,#{@domain}"
    # @regular_group_cn = "regular_group"
    # # @server.add_group("cn=#{@regular_group_cn},ou=GROUPS,#{@domain}")
    # @server.add_to_group("cn=#{@regular_group_cn},ou=GROUPS,#{@domain}", @regular_user_dn)


    # @client = Net::LDAP.new
    # @client.port = @port

  end

  after :all do
    @server.stop
  end



  describe "valid credentials" do
    it "signs the user in" do
      visit new_user_session_path
      fill_in "Username", with: @regular_user_cn
      fill_in "Password", with: @regular_user_password

      # click_on "Log in"
      find('input[name="commit"]').click
      expect(page).to have_content("DASHBOARD")
    end
  end

  # context "invalid credentials" do
  #   it "does not allow sign-in" do
  #     visit new_user_session_path
  #     fill_in "Email", with: user.email
  #     fill_in "Password", with: "invalid"

  #     click_on "Log in"
  #     expect(page).to have_content("Invalid Email or password")
  #   end
  # end
end