namespace :db do 
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts  
    make_relationships  
  end  
end

def make_users
  # let's create 100 users, the first 2 are special
  admin = User.create!(name:     'wax83', 
                       email:    'akos.bacso@gmail.com',
                       password: 'secret',
                       password_confirmation: 'secret')
  admin.toggle!(:admin)

  user = User.create!(name:     'Example User', 
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

def make_microposts
  users = User.all(limit: 6) # pulls out the 1st 6 users

  50.times do
    # generate some dummy content
    content = Faker::Lorem.sentence(5) # takes an arg, the number of words in the sentence
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first

  followed_users = users[2..50]
  followers      = users[3..40]

  # they're followed by the user
  followed_users.each do |followed|
    user.follow!(followed)
  end

  # they follow back the user
  followers.each do |follower|
    follower.follow!(user)
  end
end