FactoryBot.define do
  factory :web_hook do
    url { 'http://www.example.com/fake_hook' }
    active { true }
  end
end
