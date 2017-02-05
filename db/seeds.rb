# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# coding: utf-8

User.create(name:  "てすと太郎",
            email: "taro@test.com",
            password:              "rails",
            password_confirmation: "rails"
            )
User.create(name: "てすと次郎",
            email: "jiro@test.com",
            password:              "rails",
            password_confirmation: "rails"
            )

# Circle.create(name: "freecious")