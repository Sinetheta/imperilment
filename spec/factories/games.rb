# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :game do
    ended_at { Date.new.end_of_week }
  end
end
