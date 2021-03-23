# == Schema Information
#
# Table name: storage_locations
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  description      :string(255)
#  description_link :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe StorageLocation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
