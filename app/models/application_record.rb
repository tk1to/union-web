class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TopページからのBlog,Eventの一覧
  def self.objects_per_circles
    ids = []
    before_processing = self.pluck(:circle_id, :id, :created_at)
    circle_ids = self.group(:circle_id).pluck(:circle_id)
    circle_ids.each do |n|
      this_circle_objects = before_processing.select{|e|e[0] == n}
      ids << this_circle_objects.sort_by!{|e|e[2]}[-1][1]
    end
    objects = self.where(id: ids).order("created_at DESC")
  end
end