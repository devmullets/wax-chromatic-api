# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# create initial user and collection / wantlist until discogs oauth works

User.create(name: "Ryan")
Collection.create(user_id: 1)
Wantlist.create(user_id: 1)