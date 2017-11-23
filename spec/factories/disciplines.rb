FactoryBot.define do
  factory :discipline do
    name { |n| "#{Faker::Job.field}_#{n}" }
    description { Faker::Job.title }
  end
end
