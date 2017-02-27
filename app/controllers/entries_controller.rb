class EntriesController < ApplicationController

  before_action :authenticate_user!

  def index
    @circle = Circle.find(params[:circle_id])
    @entries = @circle.entries
  end

  def create
    Entry.create(user_id: current_user.id, circle_id: params[:circle_id])
    flash[:success] = "申請完了"
    redirect_to controller: :circles, action: :show, id: params[:circle_id]
  end

  def destroy
    Entry.find(params[:id]).destroy
    flash[:success] = "キャンセルしました"
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
end
