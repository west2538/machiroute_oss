# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 5.times do |i|
#     Post.create(title: "title #{i}", body: "body #{i}")
# end

User.create(:uid => "townsguild@gmail.com", :provider => "mastodon", :token => "23181ff1af908b5fc1de2712ea7ad414dee69f51e201c268f7cc3725cef36d7f")
Like.create(:user_id => 50, :post_id => 0)
