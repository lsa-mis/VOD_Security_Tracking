# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vod_table  :integer          default("not_selected"), not null
#  vod_action :integer          default("show"), not null
#
require 'rails_helper'

RSpec.describe AccessLookup, type: :model do
  it "is not valid without ldap_group" do
    expect(AccessLookup.new(vod_table: "dpa_exceptions", vod_action: "all")).to_not be_valid
  end

  it "is not valid without vod_table" do
    expect(AccessLookup.new(ldap_group: "lsa-vod-devs", vod_table: "not_selected", vod_action: "all")).to_not be_valid
  end

  it "is valid with all attributes" do
    access_lookup = FactoryBot.create(:access_lookup)
    expect(access_lookup).to be_valid
  end

end
