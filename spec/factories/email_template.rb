FactoryGirl.define do
  factory :email_template, class: Effective::EmailTemplate do
    from      "user@example.com"
    cc        nil
    bcc       nil
    subject   "something important"
    body      "Hello World"

    sequence(:slug, 'a') {|a| "unique_slug_#{a}" }
  end
end

