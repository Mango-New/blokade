FactoryGirl.define do
  factory :blokade_power, class: 'Blokade::Power' do
    user { |i| i.association(:luser) }
    role { |i| i.association(:role) }
  end
end
