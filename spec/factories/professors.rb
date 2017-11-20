FactoryBot.define do
  factory :professor do
    name { Faker::Name.name }
    age { rand(18..90) }
    formation_area { Faker::Coffee.notes }
    gender ['m', 'f'].sample

    trait :male do
      gender 'm'
    end

    trait :female do
      gender 'f'
    end

    factory :male_professor, traits: [:male]
    factory :female_professor, traits: [:female]
  end
end
