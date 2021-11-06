# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :game do
    ended_at { 1.week.ago }
  end
end
