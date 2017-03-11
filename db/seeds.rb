# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# coding: utf-8

names = ["太郎", "次郎", "三郎", "四郎", "五朗"]
mails = ["taro", "jiro", "saburo", "shiro", "goro"]
5.times do |i|
  user = User.create(
    name: "てすと#{names[i]}",
    email: "#{mails[i]}@test.com",
    password: "union188"
  )
  user.skip_confirmation!
  user.save
end

Circle.create(name: "ボランティアサークル", description: "定期的にボランティアをするサークルです。興味がある方は是非！")
50.times do |i|
  # Circle.create(name: "#{i}サークル")
  # User.create(name: "#{i}太郎",email: "#{i}aaa@aa.aa", password: "union188")
end
Membership.create(circle_id: 1, member_id: 1, status: 0)
Membership.create(circle_id: 1, member_id: 2, status: 3)
Membership.create(circle_id: 1, member_id: 3, status: 3)
Membership.create(circle_id: 1, member_id: 4, status: 3)
Membership.create(circle_id: 1, member_id: 5, status: 3)

Blog.create(title: "太郎のサークル設立",circle_id: 1, author_id: 1,
            content_1: "サークルを設立しました！ボランティアに興味がある方は是非入ってください！")
Event.create(title: "〇〇町ゴミ拾い！１", circle_id: 1,
  content: "ゴミ拾いを〇〇町で行います！少しでも興味がある方は是非参加してください！誰でも歓迎です！")
# 300.times do |i|
#   Blog.create(title: "#{i}番目", circle_id: 1, author_id: 1, content_1: "#{i}番目")
#   Event.create(title: "#{i}番目", circle_id: 1, content: "a")
# end


Contact.create(content: "テスト用お問い合わせ、内容が入る場所", send_user_id: 2, receive_circle_id: 1)
Entry.create(circle_id: 1, user_id: 2)

Relationship.create(follower_id: 1, followed_id: 2)
Relationship.create(follower_id: 1, followed_id: 3)

Favorite.create(circle_id: 1, user_id: 2)

Category.create(name: "ボランティア")
Category.create(name: "海外交流")
Category.create(name: "フットサル")
Category.create(name: "テニス")
Category.create(name: "バスケ")
Category.create(name: "イベント")



