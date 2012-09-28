FactoryGirl.define do 
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@somewhere.com" }
    password "foobar"
    password_confirmation "foobar"

    # FactoryGirl does'nt give a sh.t about protected attributes.
    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user # tells the association
  end
end