# == Schema Information
#
# Table name: departments
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  shortname        :string(255)
#  active_dir_group :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Department #{n}" }
    sequence(:shortname) { |n| "dept#{n}" }
    active_dir_group { "" }
  end
end
