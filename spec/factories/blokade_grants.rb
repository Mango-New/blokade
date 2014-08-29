FactoryGirl.define do
  factory :blokade_grant, class: "Blokade::Grant" do
    role { |i| i.association(:role) }
    permission { |i| i.association(:blokade_permission) }
  end
end
