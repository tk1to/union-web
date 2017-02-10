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

Circle.create(
  # id: 1,
  name: "太郎の部屋",
  description: "サークルの説明文が入る場所",
)
Membership.create(
  member_id: 1,
  circle_id: 1,
)
Circle.create(
  # id: 2,
  name: "次郎の部屋",
  description: "次郎のサークル",
)
Membership.create(
  member_id: 2,
  circle_id: 2,
)

Blog.create(
  title: "太郎のブログ",
  content: "あああああああああああ、いいいいいいいいい、ううううううううううう",
  circle_id: 1,
  author_id: 1,
)
Event.create(
  title: "勉強会",
  content: "なんでも勉強会です。",
  circle_id: 2,
)

Category.create(
  name: "ボランティア"
)
Category.create(
  name: "海外交流"
)
Category.create(
  name: "フットサル"
)

CircleCategory.create(
  circle_id: 1,
  category_id: 1
)
CircleCategory.create(
  circle_id: 2,
  category_id: 2
)

Entry.create(
  user_id: 2,
  circle_id: 1
)