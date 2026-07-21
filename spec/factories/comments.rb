FactoryBot.define do
  factory :comment do
    body { "Admin note" }
    association :resource, factory: :department
    namespace { "admin" }
  end
end
