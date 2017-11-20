FactoryBot.define do
  factory :professor do
    name { Faker::Name.name }
    age { rand(18..90) }
    formation_area { Faker::Coffee.notes }
  end
end
