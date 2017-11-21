FactoryBot.define do
  factory :university do
    name { Faker::University.name }
    acronym { name.split(' ').map { |word| word[0] }.join } # creates an acronym with the first letter of each word from name attribute
    state { Faker::StarWars.planet }
  end

  trait :prepositions_in_name do
    name { Faker::Educator.course } # simulates a name with preposition(s) like 'Master of Architectural Technology'
    acronym { name.split(' ').map { |word| word[0] if word[0] == word[0].upcase }.join } # creates acronym excluding the prepositions
  end
end