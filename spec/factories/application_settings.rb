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
FactoryBot.define do
  factory :application_setting do
    page { "MyString" }
    description { "MyString" }
    index_description { "MyText" }
    form_instruction { "MyText" }
  end
end
