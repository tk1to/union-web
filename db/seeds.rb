# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# coding: utf-8

User.create(
  # id: 1,
  name:  "てすと太郎",
  email: "taro@test.com",
  password:              "rails",
  password_confirmation: "rails",
  activated: true,
  activated_at: Time.zone.now,
)
User.create(
  # id: 2,
  name: "てすと次郎",
  email: "jiro@test.com",
  password:              "rails",
  password_confirmation: "rails",
  activated: true,
  activated_at: Time.zone.now,
)
User.create(
  # id: 3,
  name: "てすと三郎",
  email: "saburo@test.com",
  password:              "rails",
  password_confirmation: "rails",
  activated: true,
  activated_at: Time.zone.now,
)
Blog.create(title: "太郎のブログ",circle_id: 1, author_id: 1,
            content: "あああああああああああ、いいいいいいいいい、ううううううううううう")
Event.create(title: "勉強会",circle_id: 2,content: "なんでも勉強会です。")
Category.create(name: "ボランティア")
Category.create(name: "海外交流")
Category.create(name: "フットサル")
Category.create(name: "読書")

Circle.create(name: "太郎の部屋",description: "サークルの説明文が入る場所")
Circle.create(name: "次郎の部屋",description: "次郎のサークル")
for i in 1..10 do
  Circle.create(name: "#{i}番目の部屋")
  CircleCategory.create(circle_id: i, category_id: rand(3)+1)
end

Membership.create(circle_id: 1, member_id: 1)
Membership.create(circle_id: 2, member_id: 2)








