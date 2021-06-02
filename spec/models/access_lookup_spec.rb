# == Schema Information
#
# Table name: access_lookups
#
#  id         :bigint           not null, primary key
#  ldap_group :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  table      :integer          default("no_table"), not null
#  action     :integer          default("no_action"), not null
#
require 'rails_helper'

RSpec.describe AccessLookup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
