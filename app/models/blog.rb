class Blog < ActiveRecord::Base
  belongs_to :circle
  belongs_to :author, class_name: "User"
end
