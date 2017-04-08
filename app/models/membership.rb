class Membership < ApplicationRecord
  belongs_to :member, class_name: "User"
  belongs_to :circle
  validates :member_id, presence: true
  validates :circle_id, presence: true

  enum status: {chief: 0, admin: 1, editor: 2, ordinary: 3}

  def status_num
    Membership.statuses[self.status]
  end
  def status_label
    ["代表者", "管理者", "編集者", ""][self.status_num]
  end
  def self.status_label(status)
    ["代表者", "管理者", "編集者", ""][Membership.statuses[status]]
  end
end
