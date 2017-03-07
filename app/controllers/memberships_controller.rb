class MembershipsController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_chief, only: [:chief_update, :chief_edit, :admin_edit, :admin_update]
  before_action :correct_admin, only: [:status, :status_edits, :editor_edit, :editor_update, :publish_key]

  def status
    @circle     = Circle.find(params[:id])
    memberships = @circle.memberships
    @chiefs     = memberships.chief
    @admins     = memberships.admin
    @editors    = memberships.editor
  end

  def status_edits
    @circle = Circle.find(params[:id])
  end

  def chief_edit
    @circle  = Circle.find(params[:id])
    @members = @circle.members
    @memberships = @circle.memberships.select{|ms|ms.chief? || ms.admin?}
  end
  def chief_update
    @circle = Circle.find(params[:id])
    if params[:chief_update_confirmed]
      @circle.memberships.find_by(status: 0).admin!
      @circle.memberships.find(params[:elected_chief]).chief!
      flash[:success] = "変更しました。"
      redirect_to [:status, @circle]
    else
      @elected_chief = Membership.find(params[:chief_edit]).first
      if @elected_chief.chief?
        flash[:notice] = "すでに代表です。"
        redirect_to [:chief, @circle]
        return
      end
      render "chief_edit_confirm"
    end
  end

  def admin_edit
    @circle  = Circle.find(params[:id])
    @members = @circle.members
    @memberships = @circle.memberships.select{|ms|!ms.chief?}
  end
  def admin_update
    @circle = Circle.find(params[:id])
    if params[:admin_update_confirmed]
      if params[:added_admin]
        added_admin_ids   = params[:added_admin].keys.map{|n|n.to_i}
        added_admin_ids.each{|id|Membership.find(id).admin!}
      end
      if params[:removed_admin]
        removed_admin_ids = params[:removed_admin].keys.map{|n|n.to_i}
        removed_admin_ids.each{|id|Membership.find(id).ordinary!}
      end
      flash[:success] = "変更しました。"
      redirect_to [:status, @circle]
    else
      submitted_membership_ids = params[:admin_edit] ? params[:admin_edit].keys.map{|n|n.to_i} : []
      current_admin_ids = @circle.memberships.admin.ids

      added_admin_ids   = submitted_membership_ids.select{|id|!current_admin_ids.include?(id)}
      @added_admins     = added_admin_ids.map{|id|Membership.find(id)}

      removed_admin_ids = current_admin_ids.select{|id|!submitted_membership_ids.include?(id)}
      @removed_admins   = removed_admin_ids.map{|id|Membership.find(id)}
      render "admin_edit_confirm"
    end
  end

  def editor_edit
    @circle  = Circle.find(params[:id])
    @members = @circle.members
    @memberships = @circle.memberships.select{|ms|!ms.chief? && !ms.admin?}
  end
  def editor_update
    @circle = Circle.find(params[:id])
    if params[:editor_update_confirmed]
      if params[:added_editor]
        added_editor_ids   = params[:added_editor].keys.map{|n|n.to_i}
        added_editor_ids.each{|id|Membership.find(id).editor!}
      end
      if params[:removed_editor]
        removed_editor_ids = params[:removed_editor].keys.map{|n|n.to_i}
        removed_editor_ids.each{|id|Membership.find(id).ordinary!}
      end
      flash[:success] = "変更しました。"
      redirect_to [:status, @circle]
    else
      submitted_membership_ids = params[:editor_edit] ? params[:editor_edit].keys.map{|n|n.to_i} : []
      current_editor_ids = @circle.memberships.editor.ids

      added_editor_ids   = submitted_membership_ids.select{|id|!current_editor_ids.include?(id)}
      @added_editors     = added_editor_ids.map{|id|Membership.find(id)}

      removed_editor_ids = current_editor_ids.select{|id|!submitted_membership_ids.include?(id)}
      @removed_editors   = removed_editor_ids.map{|id|Membership.find(id)}
      render "editor_edit_confirm"
    end
  end

  def publish_key
    @circle = Circle.find(params[:id])
    circle_id = @circle.id
    if circle_id < 10000
      @published_url = request.host
      render "publish_url"
    else
      flash[:failuer] = "失敗"
      redirect_to circle
    end
  end

  private
    def correct_chief
      circle = Circle.find(params[:id])
      ms = current_user.memberships.find_by(circle_id: circle.id)
      if ms.blank?
        flash[:failure] = "サークルメンバーのみの機能です"
        redirect_to :top
      elsif ms[:status] != 0
        flash[:failure] = "代表のみの機能です"
        redirect_to circle
      end
    end
    def correct_admin
      circle = Circle.find(params[:id])
      ms = current_user.memberships.find_by(circle_id: circle.id)
      if ms.blank?
        flash[:failure] = "サークルメンバーのみの機能です"
        redirect_to :top
      elsif ms[:status] > 1
        flash[:failure] = "管理者のみの機能です"
        redirect_to circle
      end
    end
end





