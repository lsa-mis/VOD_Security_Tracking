require 'rails_helper'

RSpec.describe 'Home Page', type: :system do

  before do
    @home_text = Infotext.new(location: "home")
    @home_text.content = "home"
    @home_text.save
  end
  describe 'home page' do
    it 'shows the right content' do
      visit root_path
      # CSS (text-transform: uppercase) is not applied in the test layout,
      # so match the heading case-insensitively.
      expect(page.text).to match(/VOD Tools/i)
    end
  end
end