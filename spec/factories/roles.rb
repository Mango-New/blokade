FactoryGirl.define do
  factory :role do
    name "MyString"
    company { |i| i.association(:company) }
  end

  factory :sales_representative, parent: :role do
    name "Sales Representative"
    key "sales-representative"
  end

  factory :sales_manager, parent: :role do
    name "Sales Manager"
    key "sales-manager"
  end
end
