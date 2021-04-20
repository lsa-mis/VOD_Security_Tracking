require "rails_helper"

RSpec.describe "Signing in", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  describe "valid credentials" do
    it "signs the user in" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_on "Log in"
      expect(page).to have_content("Signed in successfully.")
    end
  end
end