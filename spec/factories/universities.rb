FactoryBot.define do
  factory :university do
    name { Faker::University.name }
    acronym { name.split(' ').map { |word| word[0] }.join }
    state { Faker::StarWars.planet }
  end
end