FactoryBot.define do
  factory :campus do
    name { Faker::Educator.campus }
    state { Faker::ElderScrolls.region }
  end
end
