FactoryGirl.define do
  factory :user, class: 'User' do
    sequence(:name) { |k| "MyString-#{k}" }
  end

  factory :limited_user, parent: :user do
    company { |i| i.association(:company) }

    after(:build) do |user, evaluator|
      role = Role.find_or_create_by(name: "Sales Representative", company_id: user.company.id)
      user.blokade_roles << role
    end
  end

  factory :unlimited_user, parent: :user do
    after(:build) do |user, evaluator|
      role = Role.find_or_create_by(name: "Sales Manager")
      user.blokade_roles << role
    end
  end

end
