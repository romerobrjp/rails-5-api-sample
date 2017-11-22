FactoryBot.define do
  factory :campus do
    name { Faker::Educator.campus }
    city { Faker::ElderScrolls.region }
  end
end
