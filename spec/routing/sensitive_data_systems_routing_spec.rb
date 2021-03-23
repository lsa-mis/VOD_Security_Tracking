require "rails_helper"

RSpec.describe SensitiveDataSystemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sensitive_data_systems").to route_to("sensitive_data_systems#index")
    end

    it "routes to #new" do
      expect(get: "/sensitive_data_systems/new").to route_to("sensitive_data_systems#new")
    end

    it "routes to #show" do
      expect(get: "/sensitive_data_systems/1").to route_to("sensitive_data_systems#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/sensitive_data_systems/1/edit").to route_to("sensitive_data_systems#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sensitive_data_systems").to route_to("sensitive_data_systems#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sensitive_data_systems/1").to route_to("sensitive_data_systems#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sensitive_data_systems/1").to route_to("sensitive_data_systems#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sensitive_data_systems/1").to route_to("sensitive_data_systems#destroy", id: "1")
    end
  end
end
