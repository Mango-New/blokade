FactoryGirl.define do
  factory :lead do
    sequence(:name) { |n| "Joe Blow-#{n}" }
    assignable { |i| i.association(:limited_user) }
    company { |i| i.association(:company) }
  end
end

