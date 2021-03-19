require "rails_helper"

RSpec.describe ItSecurityIncidentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/it_security_incidents").to route_to("it_security_incidents#index")
    end

    it "routes to #new" do
      expect(get: "/it_security_incidents/new").to route_to("it_security_incidents#new")
    end

    it "routes to #show" do
      expect(get: "/it_security_incidents/1").to route_to("it_security_incidents#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/it_security_incidents/1/edit").to route_to("it_security_incidents#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/it_security_incidents").to route_to("it_security_incidents#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/it_security_incidents/1").to route_to("it_security_incidents#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/it_security_incidents/1").to route_to("it_security_incidents#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/it_security_incidents/1").to route_to("it_security_incidents#destroy", id: "1")
    end
  end
end
