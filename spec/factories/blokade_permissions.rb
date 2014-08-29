FactoryGirl.define do
  factory :blokade_permission, class: 'Blokade::Permission' do
    action "MyString"
    subject_class "MyString"
    description "MyText"
    backend false
  end
end
