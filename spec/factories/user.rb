# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |x|  "user_#{x}@test.com" }
    password "password"

    factory :admin do
      sequence(:email) { |x|  "admin_#{x}@test.com" }
      after(:create) do |user|
        user.add_role :admin
      end
    end

    factory :guest do
      sequence(:email) { |x|  "guest_#{x}@test.com" }
      after(:create) do |user|
        user.add_role :guest
      end
    end
  end
end
