require "rails_helper"

RSpec.describe "AJAX helper endpoints", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ["test-group"])
  end

  describe "GET /storage_locations/is_device_required/:id" do
    it "returns whether a device is required" do
      location = FactoryBot.create(:storage_location, device_is_required: true)
      get "/storage_locations/is_device_required/#{location.id}"
      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to eq(true)
    end

    it "returns false when a device is not required" do
      location = FactoryBot.create(:storage_location, device_is_required: false)
      get "/storage_locations/is_device_required/#{location.id}"
      expect(response.parsed_body).to eq(false)
    end
  end

  describe "GET /data_classification_levels/get_data_types/:id" do
    let!(:level) { FactoryBot.create(:data_classification_level) }
    let!(:matching_type) { FactoryBot.create(:data_type, data_classification_level: level, name: "PHI") }
    let!(:other_type) { FactoryBot.create(:data_type, name: "Other") }

    it "returns data types for a classification level" do
      get "/data_classification_levels/get_data_types/#{level.id}"
      expect(response).to have_http_status(:success)
      names = response.parsed_body.map { |row| row["name"] }
      expect(names).to include("PHI")
      expect(names).not_to include("Other")
    end

    it "returns all data types when id is 0" do
      get "/data_classification_levels/get_data_types/0"
      names = response.parsed_body.map { |row| row["name"] }
      expect(names).to include("PHI", "Other")
    end
  end
end
