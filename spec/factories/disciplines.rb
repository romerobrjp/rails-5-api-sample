FactoryBot.define do
  factory :discipline do
    name { Faker::Job.field }
    description { Faker::Job.title }
  end
end
