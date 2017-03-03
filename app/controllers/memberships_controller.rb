class MembershipsController < ApplicationController

  before_action :authenticate_user!

  def status_edits
    @circle = Circle.find(params[:id])
  end

  def chief_edit
  end
  def admin_edit
    @circle  = Circle.find(params[:id])
    @members = @circle.members
  end
  def admin_update
    circle = Circle.find(params[:id])
    redirect_to [:admin, circle]
  end

  def publish_key
    circle = Circle.find(params[:id])
    circle_id = params[:id]
    if circle_id < 10000
    else
      flash[:failuer] = "失敗"
      redirect_to circle
    end
  end
end
