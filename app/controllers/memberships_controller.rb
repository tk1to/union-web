class MembershipsController < ApplicationController

  before_action :authenticate_user!

  def status_edits
    @circle = Circle.find(params[:id])
  end

  def admin_edit
    @circle  = Circle.find(params[:id])
    @members = @circle.members
  end
  def admin_update
    circle = Circle.find(params[:id])
    redirect_to [:admin, circle]
  end
end
