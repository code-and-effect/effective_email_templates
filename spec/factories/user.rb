FactoryGirl.define do
  factory :user do
    password    "password"
    password_confirmation "password"

    sequence(:email) { |n| "john-#{n}@example.com" }

    before(:create) do |user, evaluator|
      FactoryGirl.create(:email_template, slug: :after_create_user)
    end
  end

  factory :admin, parent: :user do
  end
end

