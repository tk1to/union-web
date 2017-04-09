class Contact < ApplicationRecord
  belongs_to :send_user, class_name: "User"
  belongs_to :receive_circle, class_name: "Circle"
end
