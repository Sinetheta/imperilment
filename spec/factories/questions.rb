# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    user
    answer
    reponse "What is a question?"
    correct false
    amount 200
  end
end
