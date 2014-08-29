FactoryGirl.define do
  factory :user, class: 'User' do
    sequence(:name) { |k| "MyString-#{k}" }
  end

  factory :luser, class: 'Luser', parent: :user do
    type "Luser"
    company { |i| i.association(:company) }
  end

  factory :skywire, class: 'Skywire', parent: :user do
    type "Skywire"
  end
end
