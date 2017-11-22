FactoryBot.define do
  factory :campus do
    name { |n| Faker::Educator.campus + "#{n}" }
    city { Faker::ElderScrolls.region }
  end
end
