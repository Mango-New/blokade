FactoryGirl.define do
  factory :role do
    name "MyString"
    company { |i| i.association(:company) }
  end
end
