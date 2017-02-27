class MessageRoom < ActiveRecord::Base
  belongs_to :creater, class_name: "User"
  belongs_to :created, class_name: "User"
  has_many :messages

  validates :creater_id, presence: true
  validates :created_id, presence: true

  def opponent(id)
    id == self.creater_id ? self.created : self.creater
  end

  def newest_message
    self.messages.order("created_at DESC").first
  end
end
