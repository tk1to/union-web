class EntriesController < ApplicationController

  def index
    @circle = Circle.find(params[:circle_id])
  end

  def create
    Entry.create(user_id: current_user.id, circle_id: params[:circle_id])
    flash[:success] = "申請完了"
    redirect_to controller: :circles, action: :show, id: params[:circle_id]
  end

  def destroy
    debugger
    redirect_to controller: :circles, action: :show, id: params[:circle_id]
  end
end
