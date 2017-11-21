# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# 1.upto(1000) do |n|
#   name = Faker::University.name
#   acronym = name.split(' ').map { |word| word[0] }.join

#   University.create(
#     name: "#{name}_#{n}",
#     acronym: "#{acronym}_#{n}",
#     state: Faker::StarWars.planet
#   )
# end

ufpb = University.create!(
  name: 'Universidade Federal da Paraíba',
  acronym: 'UFPB',
  state: 'Paraíba'
)

ufc = University.create!(
  name: 'Universidade Federal do Ceará',
  acronym: 'UFC',
  state: 'Ceará'
)

1.upto(2) do |n|
  Campus.create!(
    name: Faker::Educator.campus,
    city: Faker::ElderScrolls.region,
    university: ufpb
  )
end

1.upto(2) do |n|
  Campus.create!(
    name: Faker::Educator.campus,
    city: Faker::ElderScrolls.region,
    university: ufc
  )
end

# professor from UFPB campuses
1.upto(6) do |n|
  Professor.create!(
    name: Faker::Name.name,
    age: rand(18..90),
    formation_area: Faker::Coffee.notes,
    gender: ['m', 'f'].sample,
    university: ufpb,
    campus: ufpb.campuses.first
  )
end

1.upto(4) do |n|
  Professor.create!(
    name: Faker::Name.name,
    age: rand(18..90),
    formation_area: Faker::Coffee.notes,
    gender: ['m', 'f'].sample,
    university: ufpb,
    campus: ufpb.campuses.second
  )
end

# professor from UFC campuses
1.upto(6) do |n|
  Professor.create!(
    name: Faker::Name.name,
    age: rand(18..90),
    formation_area: Faker::Coffee.notes,
    gender: ['m', 'f'].sample,
    university: ufc,
    campus: ufc.campuses.first
  )
end

1.upto(4) do |n|
  Professor.create!(
    name: Faker::Name.name,
    age: rand(18..90),
    formation_area: Faker::Coffee.notes,
    gender: ['m', 'f'].sample,
    university: ufc,
    campus: ufc.campuses.second
  )
end

1.upto(15) do |n|
  Discipline.create!(
    name: Faker::Job.field,
    description: Faker::Job.title
  )
end

Professor.all.each do |p|
  1.upto (rand(1..3)) do |n|
    p.disciplines << Discipline.find(rand(1..(Discipline.count)))
  end
  p.save!
end