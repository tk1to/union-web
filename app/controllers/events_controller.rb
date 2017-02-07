class EventsController < ApplicationController

  def new
    @event = Event.new
  end
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "作成完了"
      redirect_to @event
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @circle = Circle.find(@event.circle_id)
  end

  def edit
  end

  private
    def event_params
      params.require(:event).permit(
          :title, :content, :circle_id
        )
    end
end
