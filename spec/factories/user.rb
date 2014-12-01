FactoryGirl.define do
  factory :user do
    password    "password"
    password_confirmation "password"

    sequence(:email) { |n| "john-#{n}@example.com" }
  end

  factory :admin, parent: :user do
  end
end
