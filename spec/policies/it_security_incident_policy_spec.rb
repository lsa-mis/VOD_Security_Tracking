require "rails_helper"

RSpec.describe ItSecurityIncidentPolicy, type: :policy do
  let(:it_security_incident) { FactoryBot.create(:it_security_incident) }

  subject { described_class.new(user, it_security_incident) }

  it_behaves_like "an LDAP-gated resource policy", "it_security_incidents"
end
