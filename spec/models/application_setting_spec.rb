# == Schema Information
#
# Table name: application_settings
#
#  id                :bigint           not null, primary key
#  page              :string(255)
#  description       :string(255)
#  index_description :text(65535)
#  form_instruction  :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe ApplicationSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
