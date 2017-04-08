class EventsController < ApplicationController

  before_action :authenticate_user!,                               except: [:show, :indexes, :index]
  before_action -> { member_check(params[:circle_id]) },           only: [:new, :edit, :create, :update, :destroy]
  before_action -> { status_check(params[:circle_id], "editor") }, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:circle_id]
      @circle = Circle.find(params[:circle_id])
      @events = Event.where(circle_id: @circle.id).order("created_at DESC").page(params[:page]).per(25)
    else
      @events = Event.objects_per_circles.page(params[:page]).per(25)
    end
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
      render "new"
    end
  end

  def show
    @event = Event.find(params[:id])
    @circle = @event.circle
    @be_member = @circle.be_member?
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
      render "edit"
    end
  end

  def destroy
    event = Event.find(params[:id])
    @circle = @event.circle
    event.destroy
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
end
