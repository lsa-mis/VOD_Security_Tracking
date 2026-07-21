require "rails_helper"

RSpec.describe SensitiveDataSystemPolicy, type: :policy do
  let(:sensitive_data_system) { FactoryBot.create(:sensitive_data_system) }

  subject { described_class.new(user, sensitive_data_system) }

  it_behaves_like "an LDAP-gated resource policy", "sensitive_data_systems"
end
