require "rails_helper"

RSpec.describe LegacyOsRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/legacy_os_records").to route_to("legacy_os_records#index")
    end

    it "routes to #new" do
      expect(get: "/legacy_os_records/new").to route_to("legacy_os_records#new")
    end

    it "routes to #show" do
      expect(get: "/legacy_os_records/1").to route_to("legacy_os_records#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/legacy_os_records/1/edit").to route_to("legacy_os_records#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/legacy_os_records").to route_to("legacy_os_records#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/legacy_os_records/1").to route_to("legacy_os_records#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/legacy_os_records/1").to route_to("legacy_os_records#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/legacy_os_records/1").to route_to("legacy_os_records#destroy", id: "1")
    end
  end
end
