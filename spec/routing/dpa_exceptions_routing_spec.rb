require "rails_helper"

RSpec.describe DpaExceptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/dpa_exceptions").to route_to("dpa_exceptions#index")
    end

    it "routes to #new" do
      expect(get: "/dpa_exceptions/new").to route_to("dpa_exceptions#new")
    end

    it "routes to #show" do
      expect(get: "/dpa_exceptions/1").to route_to("dpa_exceptions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/dpa_exceptions/1/edit").to route_to("dpa_exceptions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/dpa_exceptions").to route_to("dpa_exceptions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/dpa_exceptions/1").to route_to("dpa_exceptions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/dpa_exceptions/1").to route_to("dpa_exceptions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/dpa_exceptions/1").to route_to("dpa_exceptions#destroy", id: "1")
    end
  end
end
