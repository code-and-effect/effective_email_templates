FactoryGirl.define do
  factory :email_template, class: Effective::EmailTemplate do
    from      "user@example.com"
    cc        nil
    bcc       nil
    subject   "something important"
    body      "Hello World"

    sequence(:slug) {|n| "unique_slug_#{n}" }
  end
end

