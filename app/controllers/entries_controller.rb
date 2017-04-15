class EntriesController < ApplicationController

  before_action :authenticate_user!
  before_action -> { member_check(params[:circle_id]) },          only: [:index, :accept]
  before_action -> { status_check(params[:circle_id], "admin") }, only: [:index, :accept]
  before_action :external_check, only: [:create, :destroy]

  def index
    @circle = Circle.find(params[:circle_id])
    @entries = @circle.entries

    @accept_btn = true
  end

  def create
    Entry.create(user_id: current_user.id, circle_id: params[:circle_id])
    circle = Circle.find(params[:circle_id])
    circle.memberships.each do |m|
      if m.chief? || m.admin?
        if !Notification.find_by(notification_type: 3, hold_user_id: m.id, circle_id: circle.id, user_id: current_user.id)
          Notification.create(notification_type: 3, hold_user_id: m.id, circle_id: circle.id, user_id: current_user.id)
          m.member.update_attribute(:new_notifications_exist, true)
          UserMailer.notification_mail(m.member, "entry", [user_name: current_user.name, circle_name: @circle.name]).deliver_now
        end
      end
    end
    flash[:success] = "申請完了"
    redirect_to controller: :circles, action: :show, id: params[:circle_id]
  end

  def destroy
    Entry.find(params[:id]).destroy
    flash[:notice] = "キャンセルしました"
    redirect_to controller: :circles, action: :show, id: params[:circle_id]
  end

  def accept
    accepted_entry = Entry.find(params[:id])
    accepted_user  = User.find(accepted_entry.user_id)
    circle = Circle.find(params[:circle_id])
    circle.memberships.create(member_id: accepted_user.id)
    flash[:success] = "#{accepted_user.name}さんの加入を承認しました"
    accepted_entry.destroy
    redirect_to circle
  end

  private
    def external_check
      circle = Circle.find(params[:circle_id])
      if circle.members.include?(current_user)
        flash[:alert] = "メンバーではないユーザーのみの機能です"
        redirect_to :top
      end
    end
end
