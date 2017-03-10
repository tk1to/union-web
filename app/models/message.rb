class Message < ActiveRecord::Base
  belongs_to :message_room
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :content, presence: true
end
