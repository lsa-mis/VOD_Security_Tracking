# == Schema Information
#
# Table name: data_classification_levels
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe DataClassificationLevel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
