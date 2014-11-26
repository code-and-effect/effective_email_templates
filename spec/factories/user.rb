FactoryGirl.define do
  factory :user do
    email       "john@example.com"
    password    "password"
    password_confirmation "password"
  end

  factory :admin, parent: :user do
  end
end
