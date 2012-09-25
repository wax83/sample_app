namespace :db do 
  desc "Fill database with sample data"
  task populate: :environment do
    me = User.create!(name:     'wax83', 
                      email:    'akos.bacso@gmail.com',
                      password: 'secret',
                      password_confirmation: 'secret')
    me.toggle!(:admin)
    # we can't just set the admin row to true/1 
    # because admin is a protected attribute!

    User.create!(name:     'Example User', 
                 email:    'example@railstutorial.org',
                 password: 'foobar',
                 password_confirmation: 'foobar')
    
    98.times do |n|
      name     = Faker::Name.name
      email    = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name, email: email, password: password,
                   password_confirmation: password)
    end
  end  
end