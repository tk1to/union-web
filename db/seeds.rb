# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# coding: utf-8

names = ["太郎", "次郎", "三郎"]
mails = ["taro", "jiro", "saburo"]
3.times do |i|
  user = User.create(
    name: "てすと#{names[i]}",
    email: "#{mails[i]}@test.com",
    password: "union188"
  )
  user.skip_confirmation!
  user.save
end

Circle.create(name: "ボランティアサークル", description: "定期的にボランティアをするサークルです。興味がある方は是非！")
Blog.create(title: "太郎のサークル設立",circle_id: 1, author_id: 1,
            content: "サークルを設立しました！ボランティアに興味がある方は是非入ってください！")
Event.create(title: "〇〇町ゴミ拾い！１",circle_id: 2,content: "ゴミ拾いを〇〇町で行います！少しでも興味がある方は是非参加してください！誰でも歓迎です！")
Category.create(name: "ボランティア")
Category.create(name: "海外交流")
Category.create(name: "フットサル")
Category.create(name: "テニス")
Category.create(name: "バスケ")
Category.create(name: "イベント")

Circle.create(name: "太郎の部屋",description: "サークルの説明文が入る場所")
Circle.create(name: "次郎の部屋",description: "次郎のサークル")

Membership.create(circle_id: 1, member_id: 1)
Membership.create(circle_id: 2, member_id: 2)








