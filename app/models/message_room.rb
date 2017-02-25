class MessageRoom < ActiveRecord::Base
  belongs_to :creater, class_name: "User"
  belongs_to :created, class_name: "User"
  has_many :messages
end
