# == Schema Information
#
# Table name: application_settings
#
#  id         :bigint           not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe ApplicationSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
