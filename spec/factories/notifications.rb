# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  note       :string(255)
#  opendate   :datetime
#  closedate  :datetime
#  notetype   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :notification do
    note { Faker::String.random(length: 6..12) }
    opendate { Faker::Date.between(from: 2.days.from_now, to: 5.days.from_now) }
    closedate { Faker::Date.between(from: 6.days.from_now, to: 8.days.from_now) }
    notetype { "notice" }
    
  end
end
