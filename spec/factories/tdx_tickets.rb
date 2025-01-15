# == Schema Information
#
# Table name: tdx_tickets
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  records_to_tdx_type :string(255)      not null
#  records_to_tdx_id   :bigint           not null
#  ticket_link         :string(255)
#
FactoryBot.define do
  factory :tdx_ticket do
    ticket_link { Faker::Internet.url }
    association :records_to_tdx, factory: :sensitive_data_system

    trait :for_sensitive_data_system do
      association :records_to_tdx, factory: :sensitive_data_system
    end

    trait :for_legacy_os_record do
      association :records_to_tdx, factory: :legacy_os_record
    end

    trait :for_it_security_incident do
      association :records_to_tdx, factory: :it_security_incident
    end

    trait :for_dpa_exception do
      association :records_to_tdx, factory: :dpa_exception
    end
  end
end
