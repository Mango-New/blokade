FactoryGirl.define do
  factory :company do
    sequence(:name) { |n| "MyString-#{n}" }
  end
end
