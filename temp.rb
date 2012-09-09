addresses = %w[user@foo,com user_at_foo.org example.user@foo.]

addresses.each do |invalid|
  puts invalid
end

addresses2 = %w[user@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
addresses2.each do |valid|
  puts valid
end

# output =
# user@foo,com
# user_at_foo.org
# example.user@foo.
# user@foo.com
# A_US-ER@f.b.org
# frst.lst@foo.jp
# a+b@baz.cn
