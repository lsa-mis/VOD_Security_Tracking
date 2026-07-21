require "rails_helper"

RSpec.describe LegacyOsRecordPolicy, type: :policy do
  let(:legacy_os_record) { FactoryBot.create(:legacy_os_record) }

  subject { described_class.new(user, legacy_os_record) }

  it_behaves_like "an LDAP-gated resource policy", "legacy_os_records"
end
