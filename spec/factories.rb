FactoryGirl.define do 
  factory :user do
    name     "Akos Bacso"
    email    "akos.bacso@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end
end