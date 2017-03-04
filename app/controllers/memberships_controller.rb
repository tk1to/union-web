class MembershipsController < ApplicationController

  before_action :authenticate_user!

  def status
  end

  def status_edits
    @circle = Circle.find(params[:id])
  end

  def chief_edit
  end
  def admin_edit
    @circle  = Circle.find(params[:id])
    @members = @circle.members
    @memberships = @circle.memberships.select{|ms|!ms.chief?}
  end
  def admin_update
    @circle = Circle.find(params[:id])
    if params[:admin_update_confirmed]
      added_admin_ids   = params[:added_admin].keys.map{|n|n.to_i}
      removed_admin_ids = params[:removed_admin].keys.map{|n|n.to_i}

      added_admin_ids.each{|id|Membership.find(id).admin!}
      removed_admin_ids.each{|id|Membership.find(id).ordinary!}
    else
      submitted_membership_ids = params[:admin_edit].keys.map{|n|n.to_i}
      current_admin_ids = @circle.memberships.admin.ids

      added_admin_ids   = submitted_membership_ids.select{|id|!current_admin_ids.include?(id)}
      @added_admins     = added_admin_ids.map{|id|Membership.find(id)}

      removed_admin_ids = current_admin_ids.select{|id|!submitted_membership_ids.include?(id)}
      @removed_admins   = removed_admin_ids.map{|id|Membership.find(id)}
      render "admin_edit_confirm"
    end
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
