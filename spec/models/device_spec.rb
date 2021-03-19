# == Schema Information
#
# Table name: devices
#
#  id         :bigint           not null, primary key
#  serial     :string(255)
#  hostname   :string(255)
#  mac        :string(255)
#  building   :string(255)
#  room       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Device, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
