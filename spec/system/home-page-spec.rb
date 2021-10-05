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
      expect(page).to have_content('VOD TOOLS')
      sleep(inspection_time=3)
    end
  end
end