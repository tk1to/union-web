class MembershipsController < ApplicationController

  def status_edits
    @circle = Circle.find(params[:id])
  end

  def admin_edit
  end
end
