# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do
  Tag.create ({ name: Faker::GameOfThrones.house})
end

  tags = Tag.all

10.times do
  Category.create({ title: Faker::StarWars.specie})
end

20.times do
  Post.create ({ title:Faker::Book.title,
                 body: Faker::Hipster.paragraph,
                 tags: tags.sample(rand(3)+1),
                 category_id: rand(10) + 1
                 })
               end
puts "Generated things."
