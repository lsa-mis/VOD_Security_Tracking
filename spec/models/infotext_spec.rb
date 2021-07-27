# == Schema Information
#
# Table name: infotexts
#
#  id         :bigint           not null, primary key
#  location   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Infotext, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
