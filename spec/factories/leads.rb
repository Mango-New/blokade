FactoryGirl.define do
  factory :lead do
    sequence(:name) { |n| "Joe Blow-#{n}" }
    assignable { |i| i.association(:luser) }
    company { |i| i.association(:company) }
  end
end

