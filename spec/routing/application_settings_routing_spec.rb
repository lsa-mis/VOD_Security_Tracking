require "rails_helper"

RSpec.describe ApplicationSettingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/application_settings").to route_to("application_settings#index")
    end

    it "routes to #new" do
      expect(get: "/application_settings/new").to route_to("application_settings#new")
    end

    it "routes to #show" do
      expect(get: "/application_settings/1").to route_to("application_settings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/application_settings/1/edit").to route_to("application_settings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/application_settings").to route_to("application_settings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/application_settings/1").to route_to("application_settings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/application_settings/1").to route_to("application_settings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/application_settings/1").to route_to("application_settings#destroy", id: "1")
    end
  end
end
