namespace :db do 
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name:     'wax83', 
                         email:    'akos.bacso@gmail.com',
                         password: 'secret',
                         password_confirmation: 'secret')
    admin.toggle!(:admin)

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

    users = User.all(limit: 6) # pull out the 1st 6 users
    50.times do
      # generate some dummy content
      content = Faker::Lorem.sentence(5) # takes an arg, the number of words in the sentence
      users.each { |user| user.microposts.create!(content: content) }
    end
  end  
end