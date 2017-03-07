class EventsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :indexes, :index]
  before_action :member_check, only: [:new, :edit, :create, :update, :destroy]
  before_action :correct_editor, only: [:new, :create, :edit, :update, :destroy]

  def indexes
    @events = Event.all.order("created_at DESC")
  end
  def index
    @circle = Circle.find(params[:circle_id])
    @events = Event.where(circle_id: @circle.id).order("created_at DESC")
  end

  def new
    @event = Event.new
  end
  def create
    @event = Event.new(event_params)
    @event.circle_id = params[:circle_id]
    if @event.save
      flash[:success] = "作成完了"
      redirect_to [@event.circle, @event]
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @circle = @event.circle

    @be_member = @circle.members.include?(current_user)
  end

  def edit
    @event = Event.find(params[:id])
  end
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = "編集完了"
      redirect_to [@event.circle, @event]
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @circle = @event.circle
    @event.destroy
    flash[:success] = "削除完了"
    redirect_to @circle
  end

  private
    def event_params
      params.require(:event).permit(
          :circle_id,
          :title, :content,
          :picture,
          :schedule, :fee, :capacity, :place,
        )
    end
    def member_check
      circle = Circle.find(params[:circle_id])
      unless circle.members.include?(current_user)
        flash[:failure] = "メンバーのみの機能です"
        redirect_to :top
      end
    end
    def correct_editor
      circle = Circle.find(params[:circle_id])
      ms = current_user.memberships.find_by(circle_id: circle.id)
      if ms.blank?
        flash[:failure] = "サークルメンバーのみの機能です"
        redirect_to :top
      elsif ms[:status] > 2
        flash[:failure] = "編集者のみの機能です"
        redirect_to circle
      end
    end
end
