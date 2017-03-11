class MessageRoom < ActiveRecord::Base
  belongs_to :creater, class_name: "User"
  belongs_to :created, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :creater_id, presence: true
  validates :created_id, presence: true

  def opp_user(my_id)
    my_id == self.creater_id ? self.created : self.creater
  end

  def newest_message
    self.messages.order("created_at DESC").first
  end
end
