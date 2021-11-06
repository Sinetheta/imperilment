# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :question do
    user
    answer
    response { "What is a question?" }
    correct { nil }
    amount { 0 }
  end
end
